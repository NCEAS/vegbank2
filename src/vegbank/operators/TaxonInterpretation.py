import pandas as pd
import numpy as np
import time
from datetime import datetime
from psycopg import connect
from psycopg.rows import dict_row
from flask import jsonify
from vegbank.operators.operator_parent_class import Operator
from .TaxonObservation import TaxonObservation
from .Reference import Reference
from .Party import Party
from .UserDataset import UserDataset
from vegbank.operators import Validator
from vegbank.utilities import (
    read_parquet_file, 
    jsonify_error_message, 
    combine_json_return,
    merge_vb_codes,
    update_search_vector,
    UploadDataError
)



class TaxonInterpretation(Operator):
    """
    Defines operations related to the exchange of taxon interpretation data with
    VegBank.

    Taxon Interpretation: The asserted association of a taxon observation with
        a specific plant name and authority. A single taxon observation can have
        multiple taxon interpretations.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_interpretation"
        self.table_code = "ti"
        self.detail_options = ("minimal", "full")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        base_columns = {'txi.*': "*"}
        main_columns = {}
        # identify full columns
        main_columns['full'] = {
            'ti_code': "'ti.' || txi.taxoninterpretation_id",
            'to_code': "'to.' || txi.taxonobservation_id",
            'pc_code': "'pc.' || txi.plantconcept_id",
            'ob_code': "'ob.' || txo.observation_id",
            'author_obs_code': "ob.authorobscode",
            'author_plant_name': "txo.authorplantname",
            'plant_code': "code.plantname",
            'plant_name': "pc.plantname",
            'plant_label': "pc.plantconcept_id_transl",
            'py_code': "'py.' || txi.party_id",
            'party_label': "py.party_id_transl",
            'role': "ar.rolecode",
            'rf_code': "txi.reference_id",
            'rf_label': "rf.reference_id_transl",
            'interpretation_date': "txi.interpretationdate",
            'interpretation_type': "txi.interpretationtype",
            'taxon_fit': "txi.taxonfit",
            'taxon_confidence': "txi.taxonconfidence",
            'collection_number': "txi.collectionnumber",
            'group_type': "txi.grouptype",
            'notes': "txi.notes",
            'notes_public': "txi.notespublic",
            'notes_mgt': "txi.notesmgt",
            'revisions': "txi.revisions",
            'is_orig': "txi.originalinterpretation",
            'is_curr': "txi.currentinterpretation",
        }
        # identify minimal columns
        main_columns['minimal'] = {alias:col for alias, col in
            main_columns['full'].items() if alias in [
                'ti_code', 'to_code', 'pc_code', 'interpretation_date',
                'interpretation_type', 'py_code', 'rf_code', 'taxon_fit',
                'taxon_confidence', 'collection_number', 'group_type', 'notes',
                'notes_public', 'notes_mgt', 'is_orig', 'is_curr'
            ]}
        from_sql = {}
        from_sql['minimal'] = """\
            FROM txi
            """
        from_sql['full'] = from_sql['minimal'].rstrip() + """
            JOIN taxonobservation txo USING (taxonobservation_id)
            JOIN observation ob USING (observation_id)
            JOIN view_plantconcept_transl pc USING (plantconcept_id)
            LEFT JOIN LATERAL (
              SELECT pcode.plantname
                FROM plantusage pu
                JOIN plantname pcode ON pcode.plantname_id = pu.plantname_id
               WHERE pu.plantconcept_id = pc.plantconcept_id
                 AND pu.classsystem = 'Code'
               ORDER BY pu.usagestart DESC NULLS LAST
               LIMIT 1
            ) code ON true
            LEFT JOIN view_reference_transl rf ON rf.reference_id = txi.reference_id
            LEFT JOIN view_party_transl py USING (party_id)
            LEFT JOIN aux_role ar USING (role_id)
            """
        order_by_sql = """\
            ORDER BY txi.taxoninterpretation_id ASC
            """

        self.query = {}
        self.query['base'] = {
            'alias': "txi",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM taxoninterpretation AS txi",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "(emb_taxoninterpretation < 6 OR emb_taxoninterpretation IS NULL)",
                    ],
                    'params': []
                },
                'ti': {
                    'sql': "txi.taxoninterpretation_id = %s",
                    'params': ['vb_id']
                },
                'to': {
                    'sql': "txi.taxonobservation_id = %s",
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              WHERE txi.taxonobservation_id = txo.taxonobservation_id
                                AND observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': "txi.plantconcept_id = %s",
                    'params': ['vb_id']
                },
                'bundle': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM bundle
                              JOIN taxonobservation txo USING (observation_id)
                              WHERE txi.taxonobservation_id = txo.taxonobservation_id)
                        """,
                    'params': []
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
    
    def upload_all(self, request):
        """
        Orchestrate the insertion of client-provided Taxon Interpretation data into
        VegBank, starting with the Flask request containing the uploaded data
        files.

        Parameters:
            request (flask.Request): The incoming Flask request object
                containing Parquet files with Taxon Interpretation data to be
                loaded into VegBank
        Returns:
            dict: A dictionary containing either error messages in the event of
                an error, or details about what was inserted in the case of a
                successful upload. Example:
                {
                    "counts": {
                        "ti": {"inserted": 1},
                    },
                    "resources": {
                        "ti": [{"action": "inserted",
                                "user_ti_code": "my_new_interpretation_1",
                                "vb_ti_code": "ti.123"}],
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
            'ti': {
                'file_name': 'taxon_interpretations',
                'required': True,
                'user_codes': [
                    ('user_py_code', 'user_py_code', 'py'),
                    ('user_rf_code', 'user_rf_code', 'rf'),
                ]
            }
        }
        # Read each Parquet file from the request into a Pandas DataFrame
        data = {}
        validation = {
                'error': "",
                'has_error': False
        }
        dataset = {}
        for name, config in upload_files.items():
            try:
                data[name] = read_parquet_file(
                    request, config['file_name'], required=config['required'])
                if data[name] is not None:
                    data[name].replace({pd.NaT: None, np.nan: None}, inplace=True)
                    endpoint_name = None
                    print(name)
                    if name == 'ti':
                        endpoint_name = 'taxon-interpretations'
                    file_validation = Validator.validate(data[name], config['file_name'], endpoint_name)
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
                    data['ti'] = merge_vb_codes(
                        py_actions['resources']['py'], data['ti'],
                        {"user_py_code": "user_py_code",
                         "vb_py_code": "vb_py_code"})
                    data['ti'] = merge_vb_codes(
                        py_actions['resources']['py'], data['ti'],
                        {"user_py_code": "user_status_py_code",
                         "vb_py_code": "vb_status_py_code"})
                    data['ti'] = merge_vb_codes(
                        py_actions['resources']['py'], data['ti'],
                        {"user_py_code": "user_collector_py_code",
                         "vb_py_code": "vb_collector_py_code"})
                    data['ti'] = merge_vb_codes(
                        py_actions['resources']['py'], data['ti'],
                        {"user_py_code": "user_museum_py_code",
                         "vb_py_code": "vb_museum_py_code"})
                if rf_actions is not None:
                    # ... merge in newly created concept vb_rf_codes
                    data['ti'] = merge_vb_codes(
                        rf_actions['resources']['rf'], data['ti'],
                        {"user_rf_code": "user_rf_code",
                         "vb_rf_code": "vb_rf_code"})

                ti_actions = TaxonObservation(self.params).upload_taxon_interpretations(data['ti'], conn, reinterpret=True)
                dataset['taxoninterpretation'] = [item['vb_ti_code']
                                                      for item in ti_actions['resources']['ti']]
                to_return = combine_json_return(to_return, ti_actions)


                # Update party search vector
                if 'py' in to_return['resources'].keys():
                    party_ids = [self.extract_id_from_vb_code(code['vb_py_code'], 'py')
                                 for code in to_return['resources']['py']]
                    update_search_vector(conn, 'party', party_ids)
                
                # Add Dataset
                dataset_name = 'upload_' + datetime.now().strftime("%Y%m%d%H%M%S")
                dataset_description = 'Dataset created from upload on ' + \
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
