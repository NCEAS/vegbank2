import os
import pandas as pd
import numpy as np
import time
import traceback
from datetime import datetime
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


class PlantConcept(Operator):
    """
    Defines operations related to the exchange of plant concept data with
    VegBank, including usage and status (party perspective) information.

    Plant Concept: A named plant taxon according to a reference.
    Plant Status: The asserted status of a concept, according to a party
        (a.k.a., a party perspective).
    Plant Usages: Particular names associated with a plant concept, including
        their naming system, status, and effective dates.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "plant_concept"
        self.table_code = "pc"
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.nested_options = ("true", "false")
        self.sort_options = ["default", "plant_name", "obs_count"]
        self.status_options = ["any", "current", "accepted", "current_accepted"]
        self.default_status = "any"
        self.deactivation_options = ["none", "by_party", "by_party_below_order"]
        self.default_deactivation = "none"

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        if self.request.args.get('status') == 'current':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT plantconcept_id
                          FROM plantstatus ps
                          WHERE pc.plantconcept_id = ps.plantconcept_id
                            AND ps.stopdate IS NULL)
                    """,
                'params': []
            }
            and_child_status = """
                 AND stopdate IS NULL"""
        elif self.request.args.get('status') == 'accepted':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT plantconcept_id
                          FROM plantstatus ps
                          WHERE pc.plantconcept_id = ps.plantconcept_id
                            AND ps.plantconceptstatus LIKE 'accepted%%')
                    """,
                'params': []
            }
            and_child_status = """
                 AND plantconceptstatus LIKE 'accepted%%'"""
        elif self.request.args.get('status') == 'current_accepted':
            always_condition = {
                'sql': """\
                    EXISTS (
                        SELECT plantconcept_id
                          FROM plantstatus ps
                          WHERE pc.plantconcept_id = ps.plantconcept_id
                            AND ps.plantconceptstatus LIKE 'accepted%%'
                            AND ps.stopdate IS NULL)
                    """,
                'params': []
            }
            and_child_status = """
                 AND plantconceptstatus LIKE 'accepted%%'
                 AND stopdate IS NULL"""
        else:
            always_condition = {
                'sql': None,
                'params': []
            }
            and_child_status = ""

        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(pc.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'pc_code': "'pc.' || pc.plantconcept_id",
            'plant_name': "pc.plantname",
            'plant_code': "pn.plant_code",
            'plant_description': "pc.plantdescription",
            'concept_rf_code': "'rf.' || pc.reference_id",
            'concept_rf_label': "rf_pc.reference_id_transl",
            'status_rf_code': "'rf.' || ps.reference_id",
            'status_rf_label': "rf_ps.reference_id_transl",
            'obs_count': "pc.d_obscount",
            'plant_level': "ps.plantlevel",
            'status': "ps.plantconceptstatus",
            'start_date': "ps.startdate",
            'stop_date': "ps.stopdate",
            'current_accepted': ("(ps.stopdate IS NULL OR now() < ps.stopdate)"
                                 " AND LOWER(ps.plantconceptstatus) = 'accepted'"),
            'py_code': "'py.' || ps.party_id",
            'party_label': "py.party_id_transl",
            'plant_party_comments': "ps.plantpartycomments",
            'parent_pc_code': "'pc.' || ps.plantparent_id",
            'parent_name': "pa.plantname",
        }
        main_columns['full_nested'] = main_columns['full'] | {
            'usages': "pn.usages",
            'children': "children",
            'correlations': "px_group.correlations",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM pc
            LEFT JOIN LATERAL (
              SELECT *
                FROM plantstatus
                WHERE plantconcept_id = pc.plantconcept_id
                ORDER BY startdate DESC
                LIMIT 1
            ) ps ON true
            LEFT JOIN plantconcept pa ON (pa.plantconcept_id = ps.plantparent_id)
            LEFT JOIN view_reference_transl rf_pc ON pc.reference_id = rf_pc.reference_id
            LEFT JOIN view_reference_transl rf_ps ON ps.reference_id = rf_ps.reference_id
            LEFT JOIN view_party_transl py ON py.party_id = ps.party_id
            LEFT JOIN LATERAL (
              SELECT JSON_OBJECT_AGG(classsystem,
                                     RTRIM(plantname)) ->> 'Code' AS plant_code,
                     JSON_AGG(JSON_BUILD_OBJECT(
                         'class_system', classsystem,
                         'plant_name', RTRIM(plantname),
                         'status', plantnamestatus)) AS usages
                FROM plantusage
                WHERE plantconcept_id = pc.plantconcept_id
            ) pn ON true
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + f"""
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'pc_code', 'pc.' || ch_pc.plantconcept_id,
                         'plant_name', ch_pc.plantname
                       )) AS children
               FROM plantstatus ch_st
               JOIN plantconcept ch_pc USING (plantconcept_id)
               WHERE ch_st.plantparent_id = pc.plantconcept_id{
                     and_child_status}
            ) children ON true
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                         'pc_code', 'pc.' || plantconcept_id,
                         'plant_name', plantname,
                         'convergence', plantconvergence
                      )) AS correlations
                FROM plantcorrelation pcorr
                JOIN plantconcept USING (plantconcept_id)
                WHERE pcorr.plantstatus_id = ps.plantstatus_id
                  AND pcorr.correlationstop IS NULL
            ) px_group ON true
            """
        order_by_sql = {}
        order_by_sql['default'] = f"""\
            ORDER BY pc.plantconcept_id {self.direction}
            """
        order_by_sql['plant_name'] = f"""\
            ORDER BY pc.plantname {self.direction},
                     pc.plantconcept_id {self.direction}
            """
        count_direction = f"{self.direction} NULLS {'FIRST' if self.direction ==
                                                    'ASC' else 'LAST'}"
        order_by_sql['obs_count'] = f"""\
            ORDER BY pc.d_obscount {count_direction},
                     pc.plantconcept_id {self.direction}
            """

        self.query = {}
        self.query['base'] = {
            'alias': "pc",
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
                'sql': "FROM plantconcept AS pc",
                'params': []
            },
            'conditions': {
                'always': always_condition,
                'search': {
                    'sql': """\
                         (pc.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                          OR pc.plantconcept_id = CASE
                              WHEN %s ~ '^pc\.\d+$'
                              THEN regexp_replace(%s, '^pc\.', '')::integer
                              ELSE NULL
                            END)
                    """,
                    'params': ['search', 'search', 'search']
                },
                "pc": {
                    'sql': "pc.plantconcept_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM taxoninterpretation txi
                              JOIN taxonobservation txo USING (taxonobservation_id)
                              JOIN observation ob USING (observation_id)
                              WHERE pc.plantconcept_id = txi.plantconcept_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'py': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM plantstatus ps
                              WHERE pc.plantconcept_id = ps.plantconcept_id
                                AND ps.party_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'rf': {
                    'sql': "reference_id = %s",
                    'params': ['vb_id']
                },
                'to': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM taxoninterpretation txi
                              JOIN taxonobservation txo USING (taxonobservation_id)
                              WHERE pc.plantconcept_id = txi.plantconcept_id
                                AND taxonobservation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT plantconcept_id
                              FROM taxoninterpretation txi
                              JOIN taxonobservation txo USING (taxonobservation_id)
                              JOIN bundle ob USING (observation_id)
                              WHERE pc.plantconcept_id = txi.plantconcept_id)
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
                'columns': {'search_rank': 'pc.search_rank'},
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

        This only applies validations specific to plant concepts, then
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
        Orchestrate the insertion of client-provided Plant Concept data into
        VegBank, starting with the Flask request containing the uploaded data
        files.

        Parameters:
            request (flask.Request): The incoming Flask request object
                containing Parquet files with Plant Concept data to be
                loaded into VegBank
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "pc": {"inserted": 1},
                    },
                    "resources": {
                        "pc": [{"action": "inserted",
                                "user_pc_code": "my_new_concept_1",
                                "vb_pc_code": "pc.123"}],
                    }
                }
        Raises:
            QueryParameterError: If any supplied code does not match the
                expected pattern.
        """
        # Define the expected data inputs and whether or not they are required
        # TODO: Think about whether we want any other information here, and
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
            'pc': {
                'file_name': 'plant_concepts',
                'required': True,
                'user_codes':[
                    ('user_rf_code', 'user_rf_code', 'rf'),
                    ('user_status_rf_code', 'user_rf_code', 'rf'),
                    ('user_status_py_code', 'user_py_code', 'py')
                ]
            },
            'pn': {
                'file_name': 'plant_names',
                'required': False,
                'user_codes':[
                    ('user_pc_code', 'user_pc_code', 'pc'),
                    ('user_usage_py_code', 'user_py_code', 'py')
                ]
            },
            'px': {
                'file_name': 'plant_correlations',
                'required': False,
                'user_codes':[
                    ('user_pc_code', 'user_pc_code', 'pc'),
                    ('user_correlated_pc_code', 'user_pc_code', 'pc')
                ]
            },
        }
        # Read each Parquet file from the request into a Pandas DataFrame
        data = {}
        validation = {
            "has_error": False,
            "error": ""
        }
        dataset = {}
        for name, config in upload_files.items():
            try:
                data[name] = read_parquet_file(
                    request, config['file_name'], required=config['required'])
                if data[name] is not None:
                    data[name].replace({pd.NA: None, np.nan:None}, inplace=True)
                    file_validation = Validator.validate(data[name], config['file_name'])
                    user_code_validation = Validator.validate_user_codes(name, data, config.get('user_codes'), config['file_name'])
                    validation['error'] += file_validation.get('error') + user_code_validation.get('error')
                    validation['has_error'] = validation['has_error'] or file_validation['has_error'] or user_code_validation['has_error']
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

                # Prep & insert all new plant concepts
                if py_actions is not None:
                    # ... merge in newly created vb_py_codes
                    data['pc'] = merge_vb_codes(
                        py_actions['resources']['py'], data['pc'],
                        {"user_py_code": "user_status_py_code",
                         "vb_py_code": "vb_status_py_code"})
                if rf_actions is not None:
                    # ... merge in newly created concept vb_rf_codes
                    data['pc'] = merge_vb_codes(
                        rf_actions['resources']['rf'], data['pc'],
                        {"user_rf_code": "user_rf_code",
                         "vb_rf_code": "vb_rf_code"})
                    # ... merge in newly created status vb_rf_codes
                    data['pc'] = merge_vb_codes(
                        rf_actions['resources']['rf'], data['pc'],
                        {"user_rf_code": "user_status_rf_code",
                         "vb_rf_code": "vb_status_rf_code"})
                what_to_deactivate = process_option_param('deactivation',
                    request.args.get('deactivation', self.default_deactivation),
                    self.deactivation_options)

                pc_actions = self.upload_plant_concepts(
                    data['pc'], conn, what_to_deactivate = what_to_deactivate)
                dataset['plantconcept'] = [item['vb_pc_code']
                                            for item in pc_actions['resources']['pc']]
                dataset['plantname'] = [item['vb_pn_code']
                                            for item in pc_actions['resources']['pn']
                                            if item['action'] == 'INSERT']
                to_return = combine_json_return(to_return, pc_actions)

                # Prep & insert any new plant names
                if data['pn'] is not None:
                    # ... merge in newly created vb_pc_codes
                    data['pn'] = merge_vb_codes(
                        pc_actions['resources']['pc'], data['pn'],
                        {"user_pc_code": "user_pc_code",
                         "vb_pc_code": "vb_pc_code"})
                    # ... merge in newly created usage vb_ps_codes
                    # Note oddball case: we're joining on user_pc_code because
                    # users don't supply user_ps_code, but because concepts are
                    # 1:1 with statuses in our loader schema, we can treat the
                    # user_pc_code as an alias for the implicit user_ps_code
                    data['pn'] = merge_vb_codes(
                        pc_actions['resources']['ps'], data['pn'],
                        {"user_ps_code": "user_pc_code",
                         "vb_ps_code": "vb_ps_code"})
                    # ... merge in newly created usage vb_py_codes
                    if (py_actions is not None and
                            'user_usage_py_code' in data['pn'].columns):
                        data['pn'] = merge_vb_codes(
                            py_actions['resources']['py'], data['pn'],
                            {"user_py_code": "user_usage_py_code",
                             "vb_py_code": "vb_usage_py_code"})
                    pn_actions = self.upload_plant_names(data['pn'], conn)
                    dataset['plantname'] += [item['vb_pn_code']
                                            for item in pn_actions['resources']['pun']
                                            if item['action'] == 'INSERT']
                    to_return = combine_json_return(to_return, pn_actions)
                else:
                    pn_actions = None

                # Prep & insert any new plant correlations
                if data['px'] is not None:
                    # ... merge in newly created vb_pc_codes
                    data['px'] = merge_vb_codes(
                        pc_actions['resources']['pc'], data['px'],
                        {"user_pc_code": "user_pc_code",
                         "vb_pc_code": "vb_pc_code"})
                    if 'user_correlated_pc_code' in data['px'].columns:
                        data['px'] = merge_vb_codes(
                            pc_actions['resources']['pc'], data['px'],
                            {"user_pc_code": "user_correlated_pc_code",
                             "vb_pc_code": "vb_correlated_pc_code"})
                    px_actions = self.upload_plant_correlations(data['px'], conn)
                    dataset['plantcorrelation'] = [item['vb_px_code']
                                            for item in px_actions['resources']['px']]
                    to_return = combine_json_return(to_return, px_actions)
                else:
                    px_actions = None

                # Update party search vector
                if 'py' in to_return['resources'].keys():
                    party_ids = [self.extract_id_from_vb_code(code['vb_py_code'], 'py')
                                 for code in to_return['resources']['py']]
                    update_search_vector(conn, 'party', party_ids)
                # Update plant concept search vector
                plantconcept_ids = [self.extract_id_from_vb_code(code['vb_pc_code'], 'pc')
                                   for code in to_return['resources']['pc']]
                update_search_vector(conn, 'plantconcept', plantconcept_ids)

                dataset_name = 'upload_plant_concepts_' + datetime.now().strftime("%Y%m%d%H%M%S")
                dataset_description = 'Dataset created from plant concept upload on ' + \
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
            traceback.print_exc()
            return jsonify_error_message(
                f"an error occurred here during upload: {str(e)}"), 500
        return jsonify(to_return)

    def upload_plant_concepts(self, df, conn, what_to_deactivate = 'none'):
        """
        Take the Plant Concepts loader DataFrame and insert its contents
        into the plantname, plantconcept, and plantstatus tables.

        Preconditions:
        - Every vb_rf_code matches an existing reference record
        - Every vb_status_rf_code matches an existing reference record
        - Every vb_status_py_code matches an existing party record
        - One record per user_pc_code (corollary: only one status per pc)
        Step 1: INSERT INTO plantname:
                plantname <- name
                RETURNING plantname_id -> vb_pn_code
                ... correlate vb_pn_code with name
        Step 2: INSERT INTO plantconcept:
                plantname_id <- from vb_pn_code (Step 1)
                plantname <- name
                reference_id <- from vb_rf_code (user or upstream)
                plantdescription <- description
                RETURNING plantconcept_id -> vb_pc_code
                ...correlate vb_pc_code with user_pc_code
        Step 3: INSERT INTO plantconcept:
                plantconcept_id <- from vb_pc_code (Step 2)
                reference_id <- from vb_status_rf_code (user or upstream)
                party_id <- from vb_status_py_code (user or upstream)
                plantconceptstatus <- plant_concept_status
                plantparent_id <- from vb_parent_pc_code (Step 2)
                plantlevel <- plant_level
                startdate <- start_date
                stopdate <- stop_date
                plantpartycomments <- plant_party_comments
                RETURNING plantstatus_id -> vb_ps_code
        Step TODO: Set d_currentaccepted
        Step TODO: Set d_obscount

        Parameters:
            df (pandas.DataFrame): Plant concept data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "pc": {"inserted": 1},
                    },
                    "resources": {
                        "pc": [{"action": "inserted",
                                "user_pc_code": "my_new_concept_1",
                                "vb_pc_code": "pc.123"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_plant_name = table_defs_config.plant_name[:]
        config_plant_concept = table_defs_config.plant_concept[:]
        config_plant_status = table_defs_config.plant_status[:]
        table_defs = [config_plant_name,
                      config_plant_concept,
                      config_plant_status]
        # TODO: finalize this here, unless/until we move this to configuration
        required_fields = ['user_pc_code', 'name', 'vb_rf_code', 'start_date',
                           'plant_concept_status', 'vb_status_py_code']

        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "plant concepts")
        if validation['has_error']:
            raise ValueError(validation['error'])

        to_return = None

        #
        # Upsert names into plantnames table
        #

        df['user_pn_code'] = df['name']
        config_plant_name.append('user_pn_code')

        pn_actions = super().upload_to_table("plant_name", 'pn',
            config_plant_name, 'plantname_id', df, False, conn,
            validate = False)
        to_return = combine_json_return(to_return, pn_actions)

        # ... merge in newly created vb_pn_codes
        df = merge_vb_codes(
            pn_actions['resources']['pn'], df,
            {"user_pn_code": "user_pn_code",
             "vb_pn_code": "vb_pn_code"})
        config_plant_concept.append('vb_pn_code')

        #
        # Optionally deactivate old concepts from the same parties
        #

        deactivation_actions = self.deactivate_old_concepts(conn, df,
                                                            what_to_deactivate)
        to_return = combine_json_return(to_return, deactivation_actions)

        #
        # Insert concepts into plantconcept table
        #

        df['user_pc_code'] = df['user_pc_code'].astype(str)
        pc_actions = super().upload_to_table("plant_concept", 'pc',
            config_plant_concept, 'plantconcept_id', df, True, conn)
        to_return = combine_json_return(to_return, pc_actions)

        #
        # Insert status into plantstatus table
        #

        df['user_ps_code'] = df['user_pc_code']
        config_plant_status.append('user_ps_code')

        # ... merge in newly created vb_pc_codes
        df = merge_vb_codes(
            pc_actions['resources']['pc'], df,
            {"user_pc_code": "user_pc_code",
             "vb_pc_code": "vb_pc_code"})
        config_plant_status.append('vb_pc_code')

        # ... merge in any newly created vb_pc_codes for user-uploaded
        # parent concept references
        df = merge_vb_codes(
            pc_actions['resources']['pc'], df,
            {"user_pc_code": "user_parent_pc_code",
             "vb_pc_code": "vb_parent_pc_code"})

        ps_actions = super().upload_to_table("plant_status", 'ps',
            config_plant_status, 'plantstatus_id', df, True, conn)
        to_return = combine_json_return(to_return, ps_actions)

        return to_return

    def upload_plant_names(self, df, conn):
        """
        Take the Plant Names loader DataFrame and insert its contents
        into the plantname and plantusage tables.

        Preconditions:
        - Every vb_pc_code matches an existing concept record
        - Every vb_ps_code matches an existing status record
        - Every vb_usage_py_code matches an existing party record
        Step 1: INSERT INTO plantname:
                plantname <- name
                RETURNING plantname_id -> vb_pn_code
                ... correlate vb_pn_code with name
        Step 2: INSERT INTO plantusage:
                plantname_id <- from vb_pn_code (Step 1)
                plantname <- name
                plantconcept_id <- from vb_pc_code (upstream)
                usagestart <- usage_start
                usagestop <- usage_stop
                plantnamestatus <- name_status
                classsystem <- name_type
                party_id <- from vb_usage_py_code (upstream)
                plantstatus_id <- from vb_ps_code (upstream)
                RETURNING plantusage_id -> vb_pu_code

        Parameters:
            df (pandas.DataFrame): Plant names data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "pu": {"inserted": 1},
                    },
                    "resources": {
                        "pu": [{"action": "inserted",
                                "user_pu_code": "concept_1",
                                "vb_pu_code": "pu.123"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """
        # Override the default query path
        self.queries_package = f"{self.queries_root}.plant_name"

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_plant_name = table_defs_config.plant_name[:]
        config_plant_usage = table_defs_config.plant_usage[:]
        table_defs = [config_plant_name,
                      config_plant_usage]
        # TODO: finalize this here, unless/until we move this to configuration
        required_fields = ['user_pc_code', 'vb_pc_code', 'name',
                           'name_type', 'name_status']

        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "plant names")
        if validation['has_error']:
            raise ValueError(validation['error'])

        #
        # Upsert names into plantnames table
        #

        df['user_pn_code'] = df['name']
        config_plant_name.append('user_pn_code')

        pn_actions = super().upload_to_table("plant_name", 'pn',
            config_plant_name, 'plantname_id', df, False, conn,
            validate = False)

        #
        # Insert usages into plantusage table
        #

        # ... merge in newly created vb_pn_codes
        df = merge_vb_codes(
            pn_actions['resources']['pn'], df,
            {"user_pn_code": "user_pn_code",
             "vb_pn_code": "vb_pn_code"})
        config_plant_usage.append('vb_pn_code')

        df['user_pu_code'] = df['user_pc_code'] + ' ' + df['name_type']
        config_plant_usage.append('user_pu_code')
        pu_actions = super().upload_to_table("plant_usage", 'pu',
            config_plant_usage, 'plantusage_id', df, False, conn)

        to_return = {
            'resources':{
                'pun': pn_actions['resources']['pn'],
                'pu': pu_actions['resources']['pu'],
            },
            'counts':{
                'pun': pn_actions['counts']['pn'],
                'pu': pu_actions['counts']['pu'],
            }
        }
        return to_return

    def upload_plant_correlations(self, df, conn):
        """
        Take the Plant Correlations loader DataFrame and insert its contents
        into the plantcorrelation table.

        Preconditions:
        - Every vb_pc_code matches an existing plant concept record
        - Every vb_correlated_pc_code matches a concept referenced by at least
          one existing plant status record
        Step 1: (*) INSERT INTO plantcorrelation:
                plantstatus_id <- using vb_correlated_pc_code (custom logic)
                plantconcept_id <- from vb_pc_code (upstream)
                plantconvergence <- convergence_type
                correlationstart <- correlation_start
                correlationstop <- correlation_stop
                RETURNING plantcorrelation_id -> vb_px_code

        Parameters:
            df (pandas.DataFrame): Plant correlations data
            conn (psycopg.Connection): Active database connection
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "px": {"inserted": 1},
                    },
                    "resources": {
                        "px": [{"action": "inserted",
                                "user_px_code": "new_concept_1->pc.999",
                                "vb_px_code": "px.123"}],
                    }
                }
        Raises:
            ValueError: If data validation fails
        """
        # Override the default query path
        self.queries_package = f"{self.queries_root}.plant_correlation"

        # Assemble table configuration; note syntax to force a copy of the
        # config list, which we modify in-place within this method
        config_plant_correlation = table_defs_config.plant_correlation[:]
        table_defs = [config_plant_correlation]
        # TODO: finalize this here, unless/until we move this to configuration
        # e.g. what about vb_pc_code? required to *run*, but not required from
        # (or even wanted from!!) the user
        required_fields = ['vb_correlated_pc_code',
                           'convergence_type', 'correlation_start']

        # TODO: Why do we do this here, but not in other upload methods?
        config_plant_correlation.append('vb_pc_code')
        # Run basic input data validation
        validation = validate_required_and_missing_fields(df, required_fields,
            table_defs, "plant correlations")
        if validation['has_error']:
            raise ValueError(validation['error'])

        #
        # Insert correlations into plantcorrelation table
        #

        df['user_px_code'] = df['user_pc_code'] + '->' + df['vb_correlated_pc_code']
        config_plant_correlation.append('user_px_code')
        px_actions = super().upload_to_table("plant_correlation", 'px',
            config_plant_correlation, 'plantcorrelation_id', df, False, conn)

        to_return = {
            'resources':{
                'px': px_actions['resources']['px'],
            },
            'counts':{
                'px': px_actions['counts']['px'],
            }
        }
        return to_return

    def deactivate_old_concepts(self, conn, df, what_to_deactivate):
        """
        Deactivate old concepts in VegBank

        For a set of plant status records defined jointly by the combination of
        `df` and `what_to_deactivate`, set the `stopdate` to `now` if it is not
        already set to some date, and then likewise set the `usagestop` to `now`
        (if not already set) for all related plant usage records.

        Parameters:
            conn (psycopg.Connection): Active database connection
            df (pandas.DataFrame): Uploaded plant concept data
            what_to_deactivate (str): Concept deactivation strategy

        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was existing records were
                deactivated if successfully completed. Example:
                {
                    "counts": {
                        "pc_existing": {"inserted": 1},
                    },
                    "resources": {
                        "pc_existing": [{"action": "STOP",
                                "user_pc_code": "my_new_concept_1",
                                "vb_pc_code": "pc.123"}],
                    }
                }
        """
        print("Applying stop dates to old concepts...")
        if what_to_deactivate == 'by_party':
            sql_deactivate_status = """
                UPDATE plantstatus
                   SET stopdate = NOW()
                   WHERE stopdate IS NULL
                     AND party_id = ANY(%s)
                   RETURNING plantconcept_id,
                             party_id,
                             'STOP' AS action"""
        elif what_to_deactivate == 'by_party_below_order':
            sql_deactivate_status = """
                UPDATE plantstatus
                   SET stopdate = NOW()
                   WHERE stopdate IS NULL
                     AND party_id = ANY(%s)
                     AND (plantlevel IS NULL OR
                          LOWER(plantlevel) IN ('family', 'genus', 'species',
                                                'subspecies', 'variety', 'forma'))
                   RETURNING plantconcept_id,
                             party_id,
                             'STOP' AS action"""
        else:
            return  {
                "resources": {
                    "pc_existing": []
                },
                "counts": {
                    "pc_existing": {
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
              UPDATE plantusage
                 SET usagestop = NOW()
                 FROM updated_status
                 WHERE plantusage.plantconcept_id = updated_status.plantconcept_id
                   AND plantusage.usagestop IS NULL
                 RETURNING plantusage.plantconcept_id
            ) SELECT action,
                     'py.' || party_id AS vb_py_code,
                     'pc.' || plantconcept_id AS vb_pc_code
                FROM updated_status"""

        with conn.cursor() as cur:
            cur.execute(sql, (unique_status_parties,))
            pc_deactivated = cur.fetchall()

        return {
            "resources": {
                "pc_existing": pc_deactivated
            },
            "counts": {
                "pc_existing": {
                    "deactivated": len(pc_deactivated)
                }
            }
        }
