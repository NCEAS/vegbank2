import pandas as pd
import numpy as np
from datetime import datetime
import time
import traceback
import logging
from vegbank.operators.operator_parent_class import Operator
from .Reference import Reference
from .UserDataset import UserDataset
from vegbank.operators import table_defs_config, Validator
from vegbank.utilities import (
    jsonify_error_message, 
    validate_required_and_missing_fields, 
    merge_vb_codes, 
    combine_json_return, 
    read_parquet_file, 
    UploadDataError, 
    dry_run_check
)
from flask import jsonify
from psycopg import connect
from psycopg.rows import dict_row

logger = logging.getLogger(__name__)
class CoverMethod(Operator):
    """
    Defines operations related to the exchange of cover method data with
    VegBank, including associated cover index information.

    Cover Method: A defined scale, as recognized and used by data
        collectors, for estimating and recording plant cover on a plot.
    Cover Index: An individual cover class unit associated with a
        particular cover method. A single cover method can have many
        cover indices.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """
    
    def __init__(self, params):
        super().__init__(params)
        self.name = "cover_method"
        self.table_code = "cm"
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.nested_options = ("true", "false")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'cm_code': "'cm.' || cm.covermethod_id",
            'cover_type': "cm.covertype",
            'cover_estimation_method': "cm.coverestimationmethod",
            'rf_code': "'rf.' || rf.reference_id",
            'rf_label': "rf.reference_id_transl",
        }
        main_columns['full_nested'] = main_columns['full'] | {
            'cover_indexes': "cv.cover_indexes",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM cm
            LEFT JOIN view_reference_transl rf USING (reference_id)
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                      'cv_code', 'cv.' || coverindex_id,
                      'cover_code', covercode,
                      'lower_limit', lowerlimit,
                      'upper_limit', upperlimit,
                      'cover_percent', coverpercent,
                      'index_description', indexdescription)) AS cover_indexes
                FROM coverindex
                WHERE covermethod_id = cm.covermethod_id
            ) cv ON true
            """

        order_by_sql = """\
            ORDER BY cm.covermethod_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "cm",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': """\
                    FROM covermethod AS cm
                    """,
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "cm": {
                    'sql': """\
                        cm.covermethod_id = %s
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

    def upload_cover_methods(self, df, conn):
        '''
        Handles the upload of cover method and cover index data to the database.
        Expects a dataframe with all cover method and cover index data, including user codes.
        Parameters:
            - df: A pandas dataframe containing the cover method and cover index data to be uploaded. Must include user codes for both cover method and cover index.
            - conn: An active database connection to be used for the upload.
        Returns:
            - A dictionary containing the results of the upload, including any new codes generated for the cover methods and cover indices.
        '''
        config_cover_method = table_defs_config.cover_method[:]
        config_cover_index = table_defs_config.cover_index[:]
        table_defs = [config_cover_method, config_cover_index]
        required_fields = ['user_cm_code', 'cover_type', 'cover_code',
                           'cover_percent']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, 'cover_methods')
        if validation['has_error']:
            raise ValueError(validation['error'])
        to_return = None
        df['user_cm_code'] = df['user_cm_code'].astype(str)
        cover_method_codes = super().upload_to_table('cover_method', 'cm', table_defs_config.cover_method, 'covermethod_id', df, True, conn, True)

        cm_codes_df = pd.DataFrame(cover_method_codes['resources']['cm'])
        cm_codes_df = cm_codes_df[['user_cm_code', 'vb_cm_code']]

        to_return = combine_json_return(to_return, cover_method_codes)

        df = merge_vb_codes(cover_method_codes['resources']['cm'], df, 
                            {'user_cm_code': 'user_cm_code',
                            'vb_cm_code':'vb_cm_code' 
                            })
        
        config_cover_index.append('vb_cm_code')
        config_cover_index.append('user_ci_code')

        df['user_ci_code'] = np.arange(len(df)) + 1
        df['user_ci_code'] = df['user_ci_code'].astype(str)
        cover_index_codes = super().upload_to_table('cover_index', 'ci', config_cover_index, 'coverindex_id', df, False, conn, False)

        to_return = combine_json_return(to_return, cover_index_codes)

        return to_return

    def upload_all(self, request):
        '''
        Handles the upload of cover method data, including associated reference data if provided, and cover index data. Validates the uploaded data, uploads it to the database, and creates a new user dataset with the uploaded data. Expects a multipart/form-data request with parquet files for cover methods and optionally references. The cover method file must include user codes for both cover methods and cover indices. If reference data is provided, it will be uploaded first and the generated vb_rf_codes will be merged into the cover method data before uploading cover methods and cover indices.
        
        Parameters:
            - request: A Flask request object containing the uploaded files and any additional parameters. Expects parquet files for cover methods and optionally references, with specific naming conventions for the files and user code fields.
        Returns:
            - A JSON response containing the results of the upload, including any new codes generated for the cover methods and cover indices, and the new user dataset created. If any validation errors occur, returns a JSON response with the error message and a 400 status code. If any other errors occur during the upload process, returns a JSON response with the error message and a 500 status code.
        '''
        upload_files = {
            'rf':{
                'file_name': 'references',
                'required': False
            },
            'cm':{
                'file_name': 'cover_methods',
                'required': True,
                'user_codes':{
                    ('user_rf_code', 'user_rf_code', 'rf')
                }
            }
        }
        data = {}
        validation = {
            'has_error': False,
            'error': ''
        }
        dataset = {}
        to_return = None
        for name, config in upload_files.items():
            try:
                data[name] = read_parquet_file(
                    request, config['file_name'], required=config['required']
                )
                if data[name] is not None:
                    data[name].replace({pd.NaT: None, np.nan: None}, inplace=True)
                    file_validation = Validator.validate(data[name], config['file_name'])
                    user_code_validation = Validator.validate_user_codes(name, data, config.get('user_codes'), config['file_name'])
                    validation['error'] += file_validation['error'] + user_code_validation['error']
                    validation['has_error'] = file_validation['has_error'] or user_code_validation['has_error'] or validation['has_error']
            
            except UploadDataError as e:
                logger.exception(f"Error reading uploaded file for {name}: {e.message}")
                return jsonify_error_message(e.message), e.status_code

        if validation['has_error']:
            logger.error(f"Validation errors in uploaded data: {validation['error']}")
            return jsonify_error_message(validation['error']), 400
        
        try:
            with connect(**self.params, row_factory=dict_row) as conn:
                with conn.cursor() as cur:
                    if data['rf'] is not None:
                        rfs = Reference(self.params).upload_references(
                            data['rf'], conn)
                        dataset['reference'] = [item['vb_rf_code']
                                                for item in rfs['resources']['rf']]
                        to_return = combine_json_return(to_return, rfs)
                    if data['cm'] is not None:
                        if data['rf'] is not None:
                            data['cm'] = merge_vb_codes(rfs['resources']['rf'], data['cm'], 
                                                        {'user_rf_code': 'user_rf_code',
                                                        'vb_rf_code':'vb_rf_code' 
                                                        })
                        cms = self.upload_cover_methods(data['cm'], conn)
                        dataset['cover_method'] = [item['vb_cm_code']
                                                for item in cms['resources']['cm']]
                        to_return = combine_json_return(to_return, cms)
            
                dataset_name = 'upload_cover_method_' + datetime.now().strftime("%Y%m%d%H%M%S")
                dataset_description = 'Dataset created from cover method upload on ' + \
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
                end = time.time()
                logger.debug(f"Time to upload dataset: {end - start} seconds")
                to_return['counts']['ds'] = {}
                to_return['counts']['ds'] = ds['counts']['ds']
                to_return['resources']['ds'] = ds['resources']['ds']
                # Checks if user supplied dry run param and rolls back if it is true
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
            return jsonify(to_return)
        except Exception as e:
            logger.exception(f"Error during cover method upload: {str(e)}")
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500
