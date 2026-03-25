import os
import time
from datetime import datetime
import pandas as pd
import numpy as np
from vegbank.operators.operator_parent_class import Operator
from vegbank.operators import table_defs_config, Validator
from .Party import Party
from .Reference import Reference
from .UserDataset import UserDataset
from vegbank.utilities import (
    read_parquet_file,
    UploadDataError,
    validate_required_and_missing_fields,
    merge_vb_codes,
    combine_json_return,
    jsonify_error_message,
    process_option_param,
    update_search_vector,
)
from psycopg.rows import dict_row
from psycopg import connect
from flask import jsonify


class CommunityConcept(Operator):
    """
    Defines operations related to the exchange of community concept data with
    VegBank, including usage and status (party perspective) information.

    Community Concept: A named community type according to a reference.
    Community Status: The asserted status of a concept, according to a party
        (a.k.a., a party perspective).
    Community Usages: Particular names associated with a community concept,
        including their naming system, status, and effective dates.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_concept"
        self.table_code = "cc"
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.nested_options = ("true", "false")
        self.sort_options = ["default", "comm_name", "obs_count"]
        self.status_options = ["any", "current", "accepted", "current_accepted"]
        self.default_status = "any"
        self.deactivation_options = ["none", "by_party"]
        self.default_deactivation = "none"

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        if self.request.args.get('status') == 'current':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT commconcept_id
                          FROM commstatus cs
                          WHERE cc.commconcept_id = cs.commconcept_id
                            AND cs.stopdate IS NULL)
                    """,
                'params': []
            }
            and_child_status = """
                 AND stopdate IS NULL"""
        elif self.request.args.get('status') == 'accepted':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT commconcept_id
                          FROM commstatus cs
                          WHERE cc.commconcept_id = cs.commconcept_id
                            AND LOWER(cs.commconceptstatus) LIKE 'accepted%%')
                    """,
                'params': []
            }
            and_child_status = """
                 AND commconceptstatus LIKE 'accepted%%'"""
        elif self.request.args.get('status') == 'current_accepted':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT commconcept_id
                          FROM commstatus cs
                          WHERE cc.commconcept_id = cs.commconcept_id
                            AND LOWER(cs.commconceptstatus) LIKE 'accepted%%'
                            AND cs.stopdate IS NULL)
                    """,
                'params': []
            }
            and_child_status = """
                 AND commconceptstatus LIKE 'accepted%%'
                 AND stopdate IS NULL"""
        else:
            always_condition = {
                'sql': None,
                'params': []
            }
            and_child_status = ""

        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(cc.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'cc_code': "'cc.' || cc.commconcept_id",
            'comm_name': "cc.commname",
            'comm_code': "cn.comm_code",
            'comm_description': "cc.commdescription",
            'concept_rf_code': "'rf.' || cc.reference_id",
            'concept_rf_label': "rf_cc.reference_id_transl",
            'status_rf_code': "'rf.' || cs.reference_id",
            'status_rf_label': "rf_cs.reference_id_transl",
            'obs_count': "cc.d_obscount",
            'comm_level': "cs.commlevel",
            'status': "cs.commconceptstatus",
            'start_date': "cs.startdate",
            'stop_date': "cs.stopdate",
            'current_accepted': ("(cs.stopdate IS NULL OR now() < cs.stopdate)"
                                 " AND LOWER(cs.commconceptstatus) = 'accepted'"),
            'py_code': "'py.' || cs.party_id",
            'party_label': "py.party_id_transl",
            'comm_party_comments': "cs.commpartycomments",
            'parent_cc_code': "'cc.' || cs.commparent_id",
            'parent_name': "pa.commname",
        }
        main_columns['full_nested'] = main_columns['full'] | {
            'usages': "cn.usages",
            'children': "children",
            'correlations': "px_group.correlations",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM cc
            LEFT JOIN LATERAL (
              SELECT *
                FROM commstatus
                WHERE commconcept_id = cc.commconcept_id
                ORDER BY startdate DESC
                LIMIT 1
            ) cs ON true
            LEFT JOIN commconcept pa ON (pa.commconcept_id = cs.commparent_id)
            LEFT JOIN view_reference_transl rf_cc ON cc.reference_id = rf_cc.reference_id
            LEFT JOIN view_reference_transl rf_cs ON cs.reference_id = rf_cs.reference_id
            LEFT JOIN view_party_transl py ON py.party_id = cs.party_id
            LEFT JOIN LATERAL (
              SELECT JSON_OBJECT_AGG(classsystem,
                                     RTRIM(commname)) ->> 'Code' AS comm_code,
                     JSON_AGG(JSON_BUILD_OBJECT(
                         'class_system', classsystem,
                         'comm_name', RTRIM(commname),
                         'status', commnamestatus)) AS usages
                FROM commusage
                WHERE commconcept_id = cc.commconcept_id
            ) cn ON true
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + f"""
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'cc_code', 'cc.' || ch_cc.commconcept_id,
                         'comm_name', ch_cc.commname
                       )) AS children
               FROM commstatus ch_st
               JOIN commconcept ch_cc USING (commconcept_id)
               WHERE ch_st.commparent_id = cc.commconcept_id{
                     and_child_status}
            ) children ON true
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'cc_code', 'cc.' || commconcept_id,
                         'comm_name', commname,
                         'convergence', commconvergence
                      )) AS correlations
                FROM commcorrelation ccorr
                JOIN commconcept USING (commconcept_id)
                WHERE ccorr.commstatus_id = cs.commstatus_id
                  AND ccorr.correlationstop IS NULL
            ) px_group ON true
            """
        order_by_sql = {}
        order_by_sql['default'] = f"""\
            ORDER BY cc.commconcept_id {self.direction}
            """
        order_by_sql['comm_name'] = f"""\
            ORDER BY cc.commname {self.direction},
                     cc.commconcept_id {self.direction}
            """
        count_direction = f"{self.direction} NULLS {'FIRST' if self.direction ==
                                                    'ASC' else 'LAST'}"
        order_by_sql['obs_count'] = f"""\
            ORDER BY cc.d_obscount {count_direction},
                     cc.commconcept_id {self.direction}
            """

        self.query = {}
        self.query['base'] = {
            'alias': "cc",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
                'search': {
                    'columns': base_columns_search,
                    'params': ['search']
                },
            },
            'from': {
                'sql': "FROM commconcept AS cc",
                'params': []
            },
            'conditions': {
                'always': always_condition,
                'search': {
                    'sql': """\
                         (cc.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                          OR cc.commconcept_id = CASE
                              WHEN %s ~ '^cc\.\d+$'
                              THEN regexp_replace(%s, '^cc\.', '')::integer
                              ELSE NULL
                            END)
                    """,
                    'params': ['search', 'search', 'search']
                },
                "cc": {
                    'sql': "cc.commconcept_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              JOIN commclass cl USING (commclass_id)
                              JOIN observation ob USING (observation_id)
                              WHERE cc.commconcept_id = ci.commconcept_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'cl': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              JOIN commclass cl USING (commclass_id)
                              WHERE cc.commconcept_id = ci.commconcept_id
                                AND commclass_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'py': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM commstatus cs
                              WHERE cc.commconcept_id = cs.commconcept_id
                                AND cs.party_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'rf': {
                    'sql': "reference_id = %s",
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT commconcept_id
                              FROM comminterpretation ci
                              JOIN commclass cl USING (commclass_id)
                              JOIN bundle ob USING (observation_id)
                              WHERE cc.commconcept_id = ci.commconcept_id)
                        """,
                    'params': []
                },
            },
            'order_by': {
                'sql': order_by_sql[self.order_by],
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': main_columns[query_type],
                'params': []
            },
            'search': {
                'columns': {'search_rank': 'cc.search_rank'},
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql[query_type],
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to community concepts, then
        dispatches to the parent validation method for more general (and more
        permissive) validations.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # now dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        # add param for limiting by status
        params['status'] = process_option_param('status',
            request_args.get('status', self.default_status),
            self.status_options)

        return params

    def upload_all(self, request):
        """
        Orchestrate the insertion of client-provided Community Concept data into
        VegBank, starting with the Flask request containing the uploaded data
        files.

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
        # TODO: Think about whether we want anything other information here, and
        # likely factor this out some sort of configuration object
        upload_files = {
            'py': {
                'file_name': 'parties',
                'required': False
            },
            'rf': {
                'file_name': 'references',
                'required': False
            },
            'cc': {
                'file_name': 'community_concepts',
                'required': True,
                'user_codes':[
                    ('user_rf_code', 'user_rf_code', 'rf'),
                    ('user_status_rf_code', 'user_rf_code', 'rf'),
                    ('user_status_py_code', 'user_py_code', 'py'),
                    ('user_parent_cc_code', 'user_cc_code', 'cc'),
                ]
            },
            'cn': {
                'file_name': 'community_names',
                'required': False,
                'user_codes':[
                    ('user_cc_code', 'user_cc_code', 'cc'),
                    ('user_usage_py_code', 'user_py_code', 'py'),
                ]
            },
            'cx': {
                'file_name': 'community_correlations',
                'required': False,
                'user_codes':[
                    ('user_cc_code', 'user_cc_code', 'cc'),
                    ('user_correlated_cc_code', 'user_cc_code', 'cc')
                ]
            },
        }
        # Read each Parquet file from the request into a Pandas DataFrame
        data = {}
        validation = {
            'has_error': False,
            'error': ""
        }
        dataset = {}
        for name, config in upload_files.items():
            try:
                data[name] = read_parquet_file(
                    request, config['file_name'], required=config['required'])
                if data[name] is not None:
                    data[name].replace({pd.NaT: None, np.nan: None}, inplace=True)
                    file_validation = Validator.validate(data[name], config['file_name'])
                    user_code_validation = Validator.validate_user_codes(name, data, config.get('user_codes'), config['file_name'])
                    validation['error'] += file_validation['error'] + user_code_validation['error']
                    validation['has_error'] = file_validation['has_error'] or user_code_validation['has_error'] or validation['has_error']
            except UploadDataError as e:
                return jsonify_error_message(e.message), e.status_code
        if validation['has_error']:
            return jsonify_error_message(validation['error']), 400
        # Run the upload pipeline!
        try:
            to_return = None
            with connect(**self.params, row_factory=dict_row) as conn:
                # Insert any new parties
                if data['py'] is not None:
                    py_actions = Party(self.params).upload_parties(data['py'], conn)
                    dataset['party'] = [item['vb_py_code']
                                        for item in py_actions['resources']['py']]
                    to_return = combine_json_return(to_return, py_actions)
                else:
                    py_actions = None

                # Insert any new references
                if data['rf'] is not None:
                    rf_actions = Reference(self.params).upload_references(data['rf'], conn)
                    dataset['reference'] = [item['vb_rf_code']
                                            for item in rf_actions['resources']['rf']]
                    to_return = combine_json_return(to_return, rf_actions)
                else:
                    rf_actions = None

                # Prep & insert all new community concepts
                if py_actions is not None:
                    # ... merge in newly created vb_py_codes
                    data['cc'] = merge_vb_codes(
                        py_actions['resources']['py'], data['cc'],
                        {"user_py_code": "user_status_py_code",
                         "vb_py_code": "vb_status_py_code"})
                if rf_actions is not None:
                    # ... merge in newly created concept vb_rf_codes
                    data['cc'] = merge_vb_codes(
                        rf_actions['resources']['rf'], data['cc'],
                        {"user_rf_code": "user_rf_code",
                         "vb_rf_code": "vb_rf_code"})
                    # ... merge in newly created status vb_rf_codes
                    data['cc'] = merge_vb_codes(
                        rf_actions['resources']['rf'], data['cc'],
                        {"user_rf_code": "user_status_rf_code",
                         "vb_rf_code": "vb_status_rf_code"})
                what_to_deactivate = process_option_param('deactivation',
                    request.args.get('deactivation', self.default_deactivation),
                    self.deactivation_options)

                cc_actions = self.upload_community_concepts(
                    data['cc'], conn, what_to_deactivate = what_to_deactivate)
                dataset['commconcept'] = [item['vb_cc_code']
                                       for item in cc_actions['resources']['cc']]
                to_return = combine_json_return(to_return, cc_actions)

                # Prep & insert any new community names
                if data['cn'] is not None:
                    # ... merge in newly created vb_cc_codes
                    data['cn'] = merge_vb_codes(
                        cc_actions['resources']['cc'], data['cn'],
                        {"user_cc_code": "user_cc_code",
                         "vb_cc_code": "vb_cc_code"})
                    # ... merge in newly created usage vb_cs_codes
                    # Note oddball case: we're joining on user_cc_code because
                    # users don't supply user_cs_code, but because concepts are
                    # 1:1 with statuses in our loader schema, we can treat the
                    # user_cc_code as an alias for the implicit user_cs_code
                    data['cn'] = merge_vb_codes(
                        cc_actions['resources']['cs'], data['cn'],
                        {"user_cs_code": "user_cc_code",
                         "vb_cs_code": "vb_cs_code"})
                    # ... merge in newly created usage vb_py_codes
                    if py_actions is not None:
                        data['cn'] = merge_vb_codes(
                            py_actions['resources']['py'], data['cn'],
                            {"user_py_code": "user_usage_py_code",
                             "vb_py_code": "vb_usage_py_code"})
                    cn_actions = self.upload_community_names(data['cn'], conn)
                    to_return = combine_json_return(to_return, cn_actions)
                else:
                    cn_actions = None

                # Prep & insert any new community correlations
                if data['cx'] is not None:
                    # ... merge in newly created vb_cc_codes
                    data['cx'] = merge_vb_codes(
                        cc_actions['resources']['cc'], data['cx'],
                        {"user_cc_code": "user_cc_code",
                         "vb_cc_code": "vb_cc_code"})
                    data['cx'] = merge_vb_codes(
                        cc_actions['resources']['cc'], data['cx'],
                        {"user_cc_code": "user_correlated_cc_code",
                         "vb_cc_code": "vb_correlated_cc_code"})
                    cx_actions = self.upload_community_correlations(data['cx'], conn)
                    dataset['commcorrelation'] = [item['vb_cx_code']
                                       for item in cx_actions['resources']['cx']]
                    to_return = combine_json_return(to_return, cx_actions)
                else:
                    cx_actions = None

                # Update party search vector
                if 'py' in to_return['resources'].keys():
                    party_ids = [self.extract_id_from_vb_code(code['vb_py_code'], 'py')
                                 for code in to_return['resources']['py']]
                    update_search_vector(conn, 'party', party_ids)
                # Update comm concept search vector
                commconcept_ids = [self.extract_id_from_vb_code(code['vb_cc_code'], 'cc')
                                   for code in to_return['resources']['cc']]
                update_search_vector(conn, 'commconcept', commconcept_ids)

                dataset_name = 'upload_comm_concepts_' + datetime.now().strftime("%Y%m%d%H%M%S")
                dataset_description = 'Dataset created from comm concept upload on ' + \
                    datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                dataset_type = 'upload'
                dataset_input = {
                    'data': dataset,
                    'name': dataset_name,
                    'description': dataset_description,
                    'type': dataset_type
                }
                start = time.time()
                ds = UserDataset(self.params).upload_user_dataset(
                    dataset_input, conn)
                print(ds)
                end = time.time()
                print(f"Time to upload dataset: {end - start} seconds")
                to_return['counts']['ds'] = {}
                to_return['counts']['ds'] = ds['counts']['ds']
                to_return['resources']['ds'] = ds['resources']['ds']

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

    def upload_community_concepts(self, df, conn, what_to_deactivate = 'none'):
        """
        Take the Community Concepts loader DataFrame and insert its contents
        into the commname, commconcept, and commstatus tables.

        Preconditions:
        - Every vb_rf_code matches an existing reference record
        - Every vb_status_rf_code matches an existing reference record
        - Every vb_status_py_code matches an existing party record
        - One record per user_cc_code (corollary: only one status per cc)
        Step 1: INSERT INTO commname:
                commname <- name
                RETURNING commname_id -> vb_cn_code
                ... correlate vb_cn_code with name
        Step 2: INSERT INTO commconcept:
                commname_id <- from vb_cn_code (Step 1)
                commname <- name
                reference_id <- from vb_rf_code (user or upstream)
                commdescription <- description
                RETURNING commconcept_id -> vb_cc_code
                ...correlate vb_cc_code with user_cc_code
        Step 3: INSERT INTO commstatus:
                commconcept_id <- from vb_cc_code (Step 2)
                reference_id <- from vb_status_rf_code (user or upstream)
                party_id <- from vb_status_py_code (user or upstream)
                commconceptstatus <- comm_concept_status
                commparent <- from vb_parent_cc_code (Step 2)
                commlevel <- comm_level
                startdate <- start_date
                stopdate <- stop_date
                commpartycomments <- comm_party_comments
                RETURNING commstatus_id -> vb_cs_code
        Step TODO: Set d_currentaccepted
        Step TODO: Set d_obscount

        Parameters:
            df (pandas.DataFrame): Community concept data
            conn (psycopg.Connection): Active database connection
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
            ValueError: If data validation fails
        """

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_comm_name = table_defs_config.comm_name[:]
        config_comm_concept = table_defs_config.comm_concept[:]
        config_comm_status = table_defs_config.comm_status[:]
        table_defs = [config_comm_name,
                      config_comm_concept,
                      config_comm_status]
        # TODO: finalize this here, unless/until we move this to configuration
        required_fields = ['user_cc_code', 'name', 'start_date',
                           'comm_concept_status', 'vb_status_py_code']

        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "community concepts")
        if validation['has_error']:
            raise ValueError(validation['error'])

        to_return = None

        #
        # Upsert names into commnames table
        #

        df['user_cn_code'] = df['name']
        config_comm_name.append('user_cn_code')

        cn_actions = super().upload_to_table("comm_name", 'cn',
            config_comm_name, 'commname_id', df, False, conn,
            validate = False)
        to_return = combine_json_return(to_return, cn_actions)

        # ... merge in newly created vb_cn_codes
        df = merge_vb_codes(
            cn_actions['resources']['cn'], df,
            {"user_cn_code": "user_cn_code",
             "vb_cn_code": "vb_cn_code"})
        config_comm_concept.append('vb_cn_code')

        #
        # Optionally deactivate old concepts from the same parties
        #

        deactivation_actions = self.deactivate_old_concepts(conn, df,
                                                            what_to_deactivate)
        to_return = combine_json_return(to_return, deactivation_actions)

        #
        # Insert concepts into commconcept table
        #

        df['user_cc_code'] = df['user_cc_code'].astype(str)
        cc_actions = super().upload_to_table("comm_concept", 'cc',
            config_comm_concept, 'commconcept_id', df, True, conn)
        to_return = combine_json_return(to_return, cc_actions)

        #
        # Insert status into commstatus table
        #

        df['user_cs_code'] = df['user_cc_code']
        config_comm_status.append('user_cs_code')

        # ... merge in newly created vb_cc_codes
        df = merge_vb_codes(
            cc_actions['resources']['cc'], df,
            {"user_cc_code": "user_cc_code",
             "vb_cc_code": "vb_cc_code"})
        config_comm_status.append('vb_cc_code')

        # ... merge in any newly created vb_cc_codes for user-uploaded
        # parent concept references
        df = merge_vb_codes(
            cc_actions['resources']['cc'], df,
            {"user_cc_code": "user_parent_cc_code",
             "vb_cc_code": "vb_parent_cc_code"})

        cs_actions = super().upload_to_table("comm_status", 'cs',
            config_comm_status, 'commstatus_id', df, True, conn)
        to_return = combine_json_return(to_return, cs_actions)

        return to_return

    def upload_community_names(self, df, conn):
        """
        Take the Community Names loader DataFrame and insert its contents
        into the commname and commusage tables.

        Preconditions:
        - Every vb_cc_code matches an existing concept record
        - Every vb_cs_code matches an existing status record
        - Every vb_usage_py_code matches an existing party record
        Step 1: INSERT INTO commname:
                commname <- name
                RETURNING commname_id -> vb_cn_code
                ... correlate vb_cn_code with name
        Step 2: INSERT INTO commusage:
                commname_id <- from vb_cn_code (Step 1)
                commname <- name
                commconcept_id <- from vb_cc_code (upstream)
                usagestart <- usage_start
                usagestop <- usage_stop
                commnamestatus <- name_status
                classsystem <- name_type
                party_id <- from vb_usage_py_code (upstream)
                commstatus_id <- from vb_cs_code (upstream)
                RETURNING commusage_id -> vb_cu_code

        Parameters:
            df (pandas.DataFrame): Community names data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "cu": {"inserted": 1},
                    },
                    "resources": {
                        "cu": [{"action": "inserted",
                                "user_cu_code": "concept_1",
                                "vb_cu_code": "cu.123"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """
        # Override the default query path
        self.queries_package = f"{self.queries_root}.community_name"

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_comm_name = table_defs_config.comm_name[:]
        config_comm_usage = table_defs_config.comm_usage[:]
        table_defs = [config_comm_name,
                      config_comm_usage]
        # TODO: finalize this here, unless/until we move this to configuration
        required_fields = ['user_cc_code', 'vb_cc_code', 'name',
                           'name_type', 'name_status']

        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "community names")
        if validation['has_error']:
            raise ValueError(validation['error'])

        #
        # Upsert names into commnames table
        #

        df['user_cn_code'] = df['name']
        config_comm_name.append('user_cn_code')

        cn_actions = super().upload_to_table("comm_name", 'cn',
            config_comm_name, 'commname_id', df, False, conn,
            validate = False)

        #
        # Insert usages into commusage table
        #

        # ... merge in newly created vb_cn_codes
        df = merge_vb_codes(
            cn_actions['resources']['cn'], df,
            {"user_cn_code": "user_cn_code",
             "vb_cn_code": "vb_cn_code"})
        config_comm_usage.append('vb_cn_code')

        df['user_cu_code'] = df['user_cc_code'] + ' ' + df['name_type']
        config_comm_usage.append('user_cu_code')
        cu_actions = super().upload_to_table("comm_usage", 'cu',
            config_comm_usage, 'commusage_id', df, False, conn)

        to_return = {
            'resources':{
                'cun': cn_actions['resources']['cn'],
                'cu': cu_actions['resources']['cu'],
            },
            'counts':{
                'cun': cn_actions['counts']['cn'],
                'cu': cu_actions['counts']['cu'],
            }
        }
        return to_return

    def upload_community_correlations(self, df, conn):
        """
        Take the Community Correlations loader DataFrame and insert its contents
        into the commcorrelation table.

        Preconditions:
        - Every vb_cc_code matches an existing comm concept record
        - Every vb_correlated_cc_code matches a concept referenced by at least
          one existing comm status record
        Step 1: (*) INSERT INTO commcorrelation:
                commstatus_id <- using vb_correlated_cc_code (custom logic)
                commconcept_id <- from vb_cc_code (upstream)
                commconvergence <- convergence_type
                correlationstart <- correlation_start
                correlationstop <- correlation_stop
                RETURNING commcorrelation_id -> vb_cx_code

        Parameters:
            df (pandas.DataFrame): Community correlations data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "cx": {"inserted": 1},
                    },
                    "resources": {
                        "cx": [{"action": "inserted",
                                "user_cx_code": "new_concept_1->cc.999",
                                "vb_cx_code": "cx.123"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """
        # Override the default query path
        self.queries_package = f"{self.queries_root}.community_correlation"

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_comm_correlation = table_defs_config.comm_correlation[:]
        table_defs = [config_comm_correlation]
        # TODO: finalize this here, unless/until we move this to configuration
        # e.g. what about vb_cc_code? required to *run*, but not required from
        # (or even wanted from!!) the user
        required_fields = ['vb_correlated_cc_code',
                           'convergence_type', 'correlation_start']

        # TODO: Why do we do this here, but not in other upload methods?
        config_comm_correlation.append('vb_cc_code')
        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "community correlations")
        if validation['has_error']:
            raise ValueError(validation['error'])

        #
        # Insert correlations into commcorrelation table
        #

        df['user_cx_code'] = df['user_cc_code'] + '->' + df['vb_correlated_cc_code']
        config_comm_correlation.append('user_cx_code')
        cx_actions = super().upload_to_table("comm_correlation", 'cx',
            config_comm_correlation, 'commcorrelation_id', df, False, conn)

        to_return = {
            'resources':{
                'cx': cx_actions['resources']['cx'],
            },
            'counts':{
                'cx': cx_actions['counts']['cx'],
            }
        }
        return to_return

    def deactivate_old_concepts(self, conn, df, what_to_deactivate):
        """
        Deactivate old concepts in VegBank

        For a set of community status records defined jointly by the combination of
        `df` and `what_to_deactivate`, set the `stopdate` to `now` if it is not
        already set to some date, and then likewise set the `usagestop` to `now`
        (if not already set) for all related community usage records.

        Parameters:
            conn (psycopg.Connection): Active database connection
            df (pandas.DataFrame): Uploaded community concept data
            what_to_deactivate (str): Concept deactivation strategy

        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was existing records were
                deactivated if successfully completed. Example:
                {
                    "counts": {
                        "cc_existing": {"inserted": 1},
                    },
                    "resources": {
                        "cc_existing": [{"action": "STOP",
                                "user_cc_code": "my_new_concept_1",
                                "vb_cc_code": "cc.123"}],
                    }
                }
        """
        print("Applying stop dates to old concepts...")
        if what_to_deactivate == 'by_party':
            sql_deactivate_status = """
                UPDATE commstatus
                   SET stopdate = NOW()
                   WHERE stopdate IS NULL
                     AND party_id = ANY(%s)
                   RETURNING commconcept_id,
                             party_id,
                             'STOP' AS action"""
        else:
            return  {
                "resources": {
                    "cc_existing": []
                },
                "counts": {
                    "cc_existing": {
                        "deactivated": 0
                    }
                }
            }

        # Put stop dates on old concepts
        unique_status_parties = (
            df['vb_status_py_code']
            .str.removeprefix('py.')
            .astype(int)
            .unique()
            .tolist()
        )
        sql = f"""\
            WITH updated_status AS (
              {sql_deactivate_status}
            ),
            updated_usage AS (
              UPDATE commusage
                 SET usagestop = NOW()
                 FROM updated_status
                 WHERE commusage.commconcept_id = updated_status.commconcept_id
                   AND commusage.usagestop IS NULL
                 RETURNING commusage.commconcept_id
            ) SELECT action,
                     'py.' || party_id AS vb_py_code,
                     'cc.' || commconcept_id AS vb_cc_code
                FROM updated_status"""

        with conn.cursor() as cur:
            cur.execute(sql, (unique_status_parties,))
            cc_deactivated = cur.fetchall()

        return {
            "resources": {
                "cc_existing": cc_deactivated
            },
            "counts": {
                "cc_existing": {
                    "deactivated": len(cc_deactivated)
                }
            }
        }
