import os
from operators import Operator
from psycopg.rows import dict_row
from psycopg import connect
from operators import table_defs_config
from flask import jsonify
from utilities import (
    read_parquet_file,
    UploadDataError,
    validate_required_and_missing_fields,
    merge_vb_codes,
    combine_json_return,
    jsonify_error_message
)

class CommunityClassification(Operator):
    """
    Defines operations related to the exchange of community classification data
    with VegBank, potentially including community interpretations and
    classification contributors.

    Community Classification: Information about a classification activity
        leading one or more parties to apply a community concept to a
        plot observation
    Community Interpretation: The assignment of a specific community concept
        to a plot observations
    Classification Contributor: Party who contributed to the classification
        activity, acting in some role

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_classification"
        self.table_code = "cl"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.nested_options = ("true", "false")
        self.detail_options = ("minimal", "full")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        # identify full shallow columns
        main_columns['minimal'] = {
            'cl_code': "'cl.' || cl.commclass_id",
            'ob_code': "'ob.' || cl.observation_id",
            'class_start_date': "cl.classstartdate",
            'class_stop_date': "cl.classstopdate",
            'inspection': "cl.inspection",
            'table_analysis': "cl.tableanalysis",
            'multivariate_analysis': "cl.multivariateanalysis",
            'expert_system': "cl.expertsystem",
            'class_publication_rf_code': "'rf.' || cl.classpublication_id",
            'class_publication_rf_label': "rf.reference_id_transl",
            'class_notes': "cl.classnotes",
        }
        # identify minimal shallow colunms
        main_columns['full'] = main_columns['minimal'] | {
            'author_obs_code': "ob.authorobscode",
        }
        # identify full & nested columns with nesting
        nested_columns = {
            'interpretations': "interpretations",
            'contributors': "contributors",
        }
        main_columns['full_nested'] = main_columns['full'] | nested_columns
        main_columns['minimal_nested'] = main_columns['minimal'] | nested_columns
        from_sql = {}
        from_sql['minimal'] = """\
            FROM cl
            LEFT JOIN view_reference_transl rf ON reference_id = cl.classpublication_id
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN observation ob USING (observation_id)
            """
        from_sql_common_nested =  """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'py_code', 'py.' || party_id,
                         'party_label', py.party_id_transl,
                         'role', ar.rolecode)) AS contributors
                FROM classcontributor co
                LEFT JOIN view_party_transl py USING (party_id)
                LEFT JOIN aux_role ar USING (role_id)
                WHERE co.commclass_id = cl.commclass_id
            ) co ON true
            """.rstrip()
        from_sql['full_nested'] = from_sql['full'].rstrip() + \
            from_sql_common_nested.rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'ci_code', 'ci.' || ci.comminterpretation_id,
                         'cc_code', 'cc.' || ci.commconcept_id,
                         'comm_code', code.commname,
                         'comm_name', cc.commname,
                         'comm_label', cc.commconcept_id_transl,
                         'class_fit', classfit,
                         'class_confidence', classconfidence,
                         'comm_authority_rf_code', 'rf.' || ci.commauthority_id,
                         'comm_authority_name', rf.reference_id_transl,
                         'notes', notes,
                         'type', type,
                         'nomenclatural_type', nomenclaturaltype
                       )) AS interpretations
                FROM comminterpretation ci
                JOIN view_commconcept_transl cc USING (commconcept_id)
                LEFT JOIN LATERAL (
                  SELECT ccode.commname
                    FROM commusage cu
                    JOIN commname ccode ON ccode.commname_id = cu.commname_id
                   WHERE cu.commconcept_id = cc.commconcept_id
                     AND cu.classsystem = 'Code'
                   ORDER BY cu.usagestart DESC NULLS LAST
                   LIMIT 1
                ) code ON true
                LEFT JOIN view_reference_transl rf ON rf.reference_id = ci.commauthority_id
                WHERE ci.commclass_id = cl.commclass_id
            ) AS ci ON true
            """
        from_sql['minimal_nested'] = from_sql['minimal'].rstrip() + \
            from_sql_common_nested.rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'ci_code', 'ci.' || ci.comminterpretation_id,
                         'cc_code', 'cc.' || ci.commconcept_id,
                         'comm_code', code.commname,
                         'comm_name', cc.commname
                       )) AS interpretations
                FROM comminterpretation ci
                JOIN commconcept cc USING (commconcept_id)
                LEFT JOIN LATERAL (
                  SELECT ccode.commname
                    FROM commusage cu
                    JOIN commname ccode ON ccode.commname_id = cu.commname_id
                   WHERE cu.commconcept_id = cc.commconcept_id
                     AND cu.classsystem = 'Code'
                   ORDER BY cu.usagestart DESC NULLS LAST
                   LIMIT 1
                ) code ON true
                LEFT JOIN view_reference_transl rf ON rf.reference_id = ci.commauthority_id
                WHERE ci.commclass_id = cl.commclass_id
            ) AS ci ON true
            """
        order_by_sql = """\
            ORDER BY cl.commclass_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "cl",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM commclass AS cl",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "emb_commclass < 6",
                    ],
                    'params': []
                },
                "cl": {
                    'sql': "cl.commclass_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': "cl.observation_id = %s",
                    'params': ['vb_id']
                },
                'cc': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              WHERE cl.commclass_id = ci.commclass_id
                                AND commconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
            },
            'order_by': {
                'sql': order_by_sql,
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': main_columns[query_type],
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql[query_type],
            'params': []
        }

    def upload_community_classifications(self, df, conn):
        """
        Take the Community Classifications loader DataFrame and insert its contents
        into the commclass and comminterpretation tables.

        Preconditions:
        - Every vb_ob_code matches an existing plot observation record
        - Every vb_cc_code matches an existing concept record
        - Any vb_comm_class_rf_code matches an existing reference record
        - Any vb_authority_rf_code matches an existing party record
        - Multiple community interpretations for the same classification are
          implicitly supported by providing multiple records with the same
          user_cl_code but different vb_cc_codes (i.e., different attached
          concepts). Multiple interpretations attached to the same concept are
          not permitted under the same classification.
        Step 1: INSERT INTO commclass:
                observationid <- from vb_ob_code (user or upstream)
                commname <- name
                classstartdate <- class_start_date
                classstopdate <- class_stop_date
                inspection <- inspection
                tableanalysis <- table_analysis
                multivariateanalysis <- multivariate_analysis
                expertsystem <- expert_system
                classpublication_id <- from vb_comm_class_rf_code (user or upstream)
                classnotes <- class_notes
                RETURNING commclass_id -> vb_cl_code
                ...correlate vb_cl_code with user_cl_code
        Step 2: INSERT INTO comminterpretation:
                commclass_id <- from vb_cl_code (Step 1)
                commconcept_id <- from vb_cc_code
                classfit <- class_fit
                classconfidence <- class_confidence
                commauthority_id <- from vb_authority_rf_code (user or upstream)
                notes <- interp_notes
                type <- type
                nomenclaturaltype <- nomenclatural_type
                RETURNING comminterpretation_id -> vb_ci_code

        Parameters:
            df (pandas.DataFrame): Community concept data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "cl": {"inserted": 1},
                        "ci": {"inserted": 1},
                    },
                    "resources": {
                        "cl": [{"action": "inserted",
                                "user_cl_code": "my_cl_1",
                                "vb_cl_code": "cl.123"}],
                        "ci": [{"action": "inserted",
                                "user_ci_code": "my_cl_1->cc.456",
                                "vb_ci_code": "ci.234"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """
        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_comm_class = table_defs_config.comm_class[:]
        config_comm_class.append('vb_ob_code')
        config_comm_interp = table_defs_config.comm_interp[:]
        table_defs = [config_comm_class,
                      config_comm_interp]
        # TODO: finalize this here, unless/until we move this to configuration
        required_fields = ['user_cl_code', 'vb_ob_code', 'vb_cc_code']

        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "community classifications")
        if validation['has_error']:
            raise ValueError(validation['error'])

        #
        # Insert records into commclass table
        #

        df['user_cl_code'] = df['user_cl_code'].astype(str)
        cl_actions = super().upload_to_table("comm_class", 'cl',
            config_comm_class, 'commclass_id', df, True, conn)

        #
        # Insert records into comminterpretation table
        #

        df['user_ci_code'] = df['user_cl_code'] + '->' + df['vb_cc_code']
        config_comm_interp.append('user_ci_code')

        # ... merge in newly created vb_cl_codes
        df = merge_vb_codes(
            cl_actions['resources']['cl'], df,
            {"user_cl_code": "user_cl_code",
             "vb_cl_code": "vb_cl_code"})
        config_comm_interp.append('vb_cl_code')

        ci_actions = super().upload_to_table("comm_interp", 'ci',
            config_comm_interp, 'comminterpretation_id', df, True, conn)

        # TODO: decide which ones we actually want to return to the user -
        # maybe only `cl`? Or maybe both?
        to_return = {
            'resources':{
                'cl': cl_actions['resources']['cl'],
                'ci': ci_actions['resources']['ci'],
            },
            'counts':{
                'cl': cl_actions['counts']['cl'],
                'ci': ci_actions['counts']['ci'],
            }
        }
        return to_return

    def upload_all(self, request):
        """
        Orchestrate the insertion of client-provided Community Classification
        data into VegBank, starting with the Flask request containing the
        uploaded data files.

        Parameters:
            request (flask.Request): The incoming Flask request object
                containing Parquet files with Community Concept data to be
                loaded into VegBank
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "cc": {"inserted": 1},
                    },
                    "resources": {
                        "cc": [{"action": "inserted",
                                "user_cc_code": "my_new_concept_1",
                                "vb_cc_code": "cc.123"}],
                    }
                }
        Raises:
            QueryParameterError: If any supplied code does not match the
                expected pattern.
        """
        # Define the expected data inputs and whether or not they are required
        # TODO: Bring references table into the upload workflow to allow
        # users to add new references that they link to in their
        # classification/intepretation records
        upload_files = {
            'cl': {
                'file_name': 'community_classifications',
                'required': False
            },
        }
        # Read each Parquet file from the request into a Pandas DataFrame
        data = {}
        for name, config in upload_files.items():
            try:
                data[name] = read_parquet_file(
                    request, config['file_name'], required=config['required'])
            except UploadDataError as e:
                return jsonify_error_message(e.message), e.status_code

        # Run the upload pipeline!
        try:
            to_return = None
            with connect(**self.params, row_factory=dict_row) as conn:
                # Prep & insert any new community classifications
                cl_actions = self.upload_community_classifications(data['cl'], conn)
                to_return = combine_json_return(to_return, cl_actions)

                # If this is a dry-run upload, roll back transaction and embed
                # the informational JSON response in a dry-run wrapper message
                if request.args.get('dry_run', 'false').lower() == 'true':
                    conn.rollback()
                    message = "dry run - rolling back transaction."
                    return jsonify({
                        "message": message,
                        "dry_run_data": to_return
                    })
            conn.close()
        except Exception as e:
            return jsonify_error_message(
                f"an error occurred here during upload: {str(e)}"), 500
        return jsonify(to_return)
