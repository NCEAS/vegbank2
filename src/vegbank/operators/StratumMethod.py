import os
import psycopg
import pandas as pd
import numpy as np
import time
from datetime import datetime
import traceback
from vegbank.operators.operator_parent_class import Operator
from vegbank.operators import table_defs_config, Validator
from .Reference import Reference
from .UserDataset import UserDataset
from vegbank.utilities import (
    load_sql,
    jsonify_error_message,
    allowed_file,
    QueryParameterError,
    validate_required_and_missing_fields,
    merge_vb_codes,
    combine_json_return,
    read_parquet_file,
    UploadDataError,
    dry_run_check
)
from psycopg import ClientCursor, connect
from psycopg.rows import dict_row
from flask import jsonify

class StratumMethod(Operator):
    """
    Defines operations related to the exchange of stratum method data with
    VegBank, including associated stratum type information.

    Stratum Method: A defined method for categorizing vegetation strata within a
        plot observation.
    Stratum Type: The index, name, and description of an individual stratum
        associated with a particular stratum method. A single stratum
        method can have many stratum types.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "stratum_method"
        self.table_code = "sm"
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.nested_options = ("true", "false")

    def configure_query(self, *args, **kwargs):
        query_type = self.detail
        if self.with_nested == 'true':
            query_type += "_nested"

        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'sm_code': "'sm.' || sm.stratummethod_id",
            'stratum_method_name': "sm.stratummethodname",
            'stratum_method_description': "sm.stratummethoddescription",
            'stratum_assignment': "sm.stratumassignment",
            'rf_code': "'rf.' || rf.reference_id",
            'rf_label': "rf.reference_id_transl",
        }
        main_columns['full_nested'] = main_columns['full'] | {
            'stratum_types': "sy.stratum_types",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM sm
            LEFT JOIN view_reference_transl rf USING (reference_id)
            """
        from_sql['full_nested'] = from_sql['full'].rstrip() + """
            LEFT JOIN LATERAL (
              SELECT JSON_AGG(JSON_BUILD_OBJECT(
                      'sy_code', 'sy.' || stratumtype_id,
                      'stratum_index', stratumindex,
                      'stratum_name', stratumname,
                      'stratum_description', stratumdescription)) AS stratum_types
                FROM stratumtype
                WHERE stratummethod_id = sm.stratummethod_id
            ) sy ON true
            """

        order_by_sql = """\
            ORDER BY sm.stratummethod_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "sm",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': """\
                    FROM stratummethod AS sm
                    """,
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "sm": {
                    'sql': """\
                        sm.stratummethod_id = %s
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

    def upload_stratum_method_old(self, request, params):
        """
        Uploads stratum method and stratum type data from a file, validates it, and inserts it into the database.
        Parameters:
            request (Request): The incoming request containing the file to be uploaded.
            params (dict): Database connection parameters.
            Set via env variable in vegbankapi.py. Keys are: 
                dbname, user, host, port, password
        Returns:
            Response: A JSON response containing the results of the upload operation, including 
                      inserted and matched records, or an error message if the operation fails.
        Raises:
            ValueError: If there are unsupported columns in the uploaded data, if references do not 
                        exist in the database, or if there are no new stratum methods to insert.
        """

        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

        stratum_method_fields = table_defs_config.stratum_method
        stratum_type_fields = table_defs_config.stratum_type

        to_return = {}

        try:
            df = pd.read_parquet(file)
            print(f"DataFrame loaded with {len(df)} records.")

            df.columns = map(str.lower, df.columns)
            # Checking if the user submitted any unsupported columns
            additional_columns = set(df.columns) - set(stratum_method_fields) - set(stratum_type_fields)
            if(len(additional_columns) > 0):
                return jsonify_error_message(f"Your data must only contain fields included in the plot observation schema. The following fields are not supported: {additional_columns} ")

            df.replace({pd.NaT: None}, inplace=True)
            df.replace({np.nan: None}, inplace=True)

            stratum_method_df = df[stratum_method_fields]
            stratum_method_df = stratum_method_df.drop_duplicates()

            print(str(stratum_method_df))
            print("---------------")
            stratum_method_inputs = list(stratum_method_df.itertuples(index=False, name=None))

            with psycopg.connect(
                **params, cursor_factory=ClientCursor, row_factory=dict_row
            ) as conn:
                with conn.cursor() as cur:
                    with conn.transaction():

                        sql_create_sm_temp_table = (
                            "/stratum_method/create_stratum_method_temp_table.sql"
                        )
                        sql = load_sql(self.queries_package, sql_create_sm_temp_table)
                        cur.execute(sql)

                        sql_insert_sm_temp_table = (
                            "/stratum_method/insert_stratum_methods_to_temp_table.sql"
                        )
                        sql = load_sql(self.queries_package, sql_insert_sm_temp_table)
                        cur.executemany(sql, stratum_method_inputs)

                        print("about to run validate stratum methods")
                        sql_validate_sm_temp_table = (
                            "/stratum_method/validate_stratum_methods.sql"
                        )
                        sql = load_sql(self.queries_package, sql_validate_sm_temp_table)
                        cur.execute(sql)
                        existing_records = cur.fetchall()
                        print("existing records: " + str(existing_records))

                        cur.nextset()
                        new_references = cur.fetchall()
                        print("new references: " + str(new_references))

                        if len(new_references) > 0:
                            raise ValueError(
                                f"The following references do not exist in the database: {new_references}."
                                + " Please add them to the reference table before uploading new stratum methods."
                            )

                        sql_insert_sm_temp_to_perm_table = "/stratum_method/insert_stratum_methods_from_temp_table_to_permanent.sql"
                        sql = load_sql(
                            self.queries_package, sql_insert_sm_temp_to_perm_table
                        )
                        cur.execute(sql)
                        inserted_stratum_method_records = cur.fetchall()
                        print("inserted records: " + str(inserted_stratum_method_records))

                        if(len(inserted_stratum_method_records) == 0 and len(existing_records) == 0):
                            raise ValueError("No new stratum methods to insert. Please check your data for duplicates.")

                        inserted_stratum_method_records_df = pd.DataFrame(inserted_stratum_method_records)
                        print("inserted_stratum_method_records_df: " + str(inserted_stratum_method_records_df))

                        stratum_type_df = pd.merge(df, inserted_stratum_method_records_df[['stratummethodname', 'stratummethod_id']], on='stratummethodname')
                        stratum_type_df = stratum_type_df[stratum_type_fields]
                        stratum_type_inputs = list(stratum_type_df.itertuples(index=False, name=None))

                        print("stratum_type_inputs: " + str(stratum_type_inputs))

                        sql_create_st_temp_table = (
                            "/stratum_type/create_stratum_type_temp_table.sql"
                        )
                        sql = load_sql(self.queries_package, sql_create_st_temp_table)
                        cur.execute(sql)

                        sql_insert_st_temp_table = (
                            "/stratum_type/insert_stratum_types_to_temp_table.sql"
                        )
                        sql = load_sql(self.queries_package, sql_insert_st_temp_table)
                        cur.executemany(sql, stratum_type_inputs)

                        sql_insert_st_temp_to_perm_table = (
                            "/stratum_type/insert_stratum_types_from_temp_table_to_permanent.sql"
                        )
                        sql = load_sql(self.queries_package, sql_insert_st_temp_to_perm_table)
                        cur.execute(sql)

                        inserted_stratum_type_records = cur.fetchall()
                        print("inserted stratum type records: " + str(inserted_stratum_type_records))

                        stratummethod_ids = []
                        for record in inserted_stratum_method_records:
                            stratummethod_ids.append(record['stratummethod_id'])
                        print("stratummethod_ids: " + str(stratummethod_ids))

                        sql_create_sm_acc_codes = (
                            "/stratum_method/create_stratum_method_accession_codes.sql"
                        )
                        sql = load_sql(self.queries_package, sql_create_sm_acc_codes)
                        cur.execute(sql, (stratummethod_ids, ))
                        new_sm_codes = cur.fetchall()

                        sm_codes_df = pd.DataFrame(new_sm_codes)
                        print("sm_codes_df" + str(sm_codes_df))
                        df['stratummethodname'] = df['stratummethodname'].astype(str)
                        sm_codes_df['stratummethodname'] = sm_codes_df['stratummethodname'].astype(str)

                        joined_df = pd.merge(df, sm_codes_df, on='stratummethodname')
                        print("----------------------------------------")
                        print(str(joined_df))

                        to_return_stratum_methods = []
                        to_return_stratum_types = []
                        for index, record in joined_df.iterrows():
                            to_return_stratum_methods.append({
                                "user_code": record['user_code'], 
                                "sm_code": record['accessioncode'],
                                "stratummethodname": record['stratummethodname'],
                                "action":"inserted"
                            })
                        for record in inserted_stratum_type_records:
                            print("record: " + str(record))
                            to_return_stratum_types.append({
                                "sm_code": "sm." + str(record['stratummethod_id']), 
                                "st_code": "st." + str(record['stratumtype_id']),
                                "stratumname": record['stratumname'],
                                "action":"inserted"
                            })
                        for record in existing_records:
                            to_return_stratum_methods.append({
                                "user_code": record["user_code"],
                                "sm_code": record['user_code'],
                                "stratummethodname": record['stratummethodname'],
                                "action":"matched"
                            })
                        to_return["resources"] = {
                            "sm": to_return_stratum_methods,
                            "st": to_return_stratum_types
                        }
                        to_return["counts"] = {
                            "sm":{
                                "inserted": len(joined_df),
                                "matched": len(existing_records)
                            },
                            "st":{
                                "inserted": len(inserted_stratum_type_records)
                            }
                        }
            conn.close()      

            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500

    def upload_stratum_methods(self, df, conn):
        config_stratum_method = table_defs_config.stratum_method[:]
        config_stratum_type = table_defs_config.stratum_type[:]
        table_defs = [config_stratum_method, config_stratum_type]
        required_fields = ['user_sm_code', 'stratum_method_name']
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, 'stratum_methods')
        if validation['has_error']:
            raise ValueError(validation['error'])
        to_return = None
        df['user_sm_code'] = df['user_sm_code'].astype(str)
        stratum_method_codes = super().upload_to_table('stratum_method', 'sm', table_defs_config.stratum_method, 'stratummethod_id', df, True, conn, True)

        sm_codes_df = pd.DataFrame(stratum_method_codes['resources']['sm'])
        sm_codes_df = sm_codes_df[['user_sm_code', 'vb_sm_code']]

        to_return = combine_json_return(to_return, stratum_method_codes)

        df = merge_vb_codes(stratum_method_codes['resources']['sm'], df, 
                            {'user_sm_code': 'user_sm_code',
                             'vb_sm_code': 'vb_sm_code'
                            })
        config_stratum_type.append('vb_sm_code')
        config_stratum_type.append('user_st_code')

        df['user_st_code'] = np.arange(len(df)) + 1
        df['user_st_code'] = df['user_st_code'].astype(str)
        stratum_type_codes = super().upload_to_table('stratum_type', 'st', config_stratum_type, 'stratumtype_id', df, True, conn, False)

        to_return = combine_json_return(to_return, stratum_type_codes)

        return to_return
    
    def upload_all(self, request):
        '''
        Handles the upload of stratum method data, including associated reference data if provided, and stratum type data. Validates the uploaded data, uploads it to the database, and creates a new user dataset with the uploaded data. Expects a multipart/form-data request with parquet files for stratum methods and optionally references. The stratum method file must include user codes for stratum methods, and user codes will be created for stratum types based on row number. If reference data is provided, it will be uploaded first and the generated vb_rf_codes will be merged into the stratum method data before uploading stratum methods and stratum types.
        
        Parameters:
            - request: A Flask request object containing the uploaded files and any additional parameters. Expects parquet files for stratum methods and optionally references, with specific naming conventions for the files and user code fields.
        Returns:
            - A JSON response containing the results of the upload, including any new codes generated for the stratum methods and stratum types, and the new user dataset created. If any validation errors occur, returns a JSON response with the error message and a 400 status code. If any other errors occur during the upload process, returns a JSON response with the error message and a 500 status code.
        '''
        upload_files = {
            'rf':{
                'file_name': 'references',
                'required': False
            },
            'sm':{
                'file_name': 'stratum_methods',
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
                return jsonify_error_message(e.message), e.status_code

        if validation['has_error']:
            return jsonify_error_message(validation['error']), 400
        
        try:
            with connect(**self.params, row_factory=dict_row) as conn:
                with conn.cursor() as cur:
                    if data['rf'] is not None:
                        print("references are found")
                        rfs = Reference(self.params).upload_references(
                            data['rf'], conn)
                        dataset['reference'] = [item['vb_rf_code']
                                                for item in rfs['resources']['rf']]
                        to_return = combine_json_return(to_return, rfs)
                    if data['sm'] is not None:
                        if data['rf'] is not None:
                            data['sm'] = merge_vb_codes(rfs['resources']['rf'], data['sm'], 
                                                        {'user_rf_code': 'user_rf_code',
                                                        'vb_rf_code':'vb_rf_code' 
                                                        })
                        sms = self.upload_stratum_methods(data['sm'], conn)
                        dataset['stratum_method'] = [item['vb_sm_code']
                                                for item in sms['resources']['sm']]
                        to_return = combine_json_return(to_return, sms)
            
                dataset_name = 'upload_stratum_method_' + datetime.now().strftime("%Y%m%d%H%M%S")
                dataset_description = 'Dataset created from stratum method upload on ' + \
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
                # Checks if user supplied dry run param and rolls back if it is true
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500