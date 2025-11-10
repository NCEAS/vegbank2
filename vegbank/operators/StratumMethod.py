import os
from flask import jsonify
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import traceback
from operators import Operator, table_defs_config
from utilities import jsonify_error_message, allowed_file, QueryParameterError


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
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'sm_code': "'sm.' || sm.stratummethod_id",
            'stratum_method_name': "sm.stratummethodname",
            'stratum_method_description': "sm.stratummethoddescription",
            'stratum_assignment': "sm.stratumassignment",
            'rf_code': "'rf.' || rf.reference_id",
            'rf_name': "rf.shortname",
            'sy_code': "'sy.' || sm.stratumtype_id",
            'stratum_index': "sm.stratumindex",
            'stratum_name': "sm.stratumname",
            'stratum_description': "sm.stratumdescription",
        }
        from_sql = """\
            FROM sm
            LEFT JOIN reference rf USING (reference_id)
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
                    LEFT JOIN stratumtype sy USING (stratummethod_id)
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
                'columns': main_columns[self.detail],
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql,
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to stratum methods, then
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
        # specifically require detail to be "full" for stratum methods
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # now dispatch to the base validation method
        return super().validate_query_params(request_args)

    def upload_stratum_method(self, request, params):
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
            #Checking if the user submitted any unsupported columns
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
            

            with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
                
                with conn.cursor() as cur:
                    with conn.transaction():
                        
                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_method/create_stratum_method_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_method/insert_stratum_methods_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, stratum_method_inputs)
                        
                        print("about to run validate stratum methods")
                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_method/validate_stratum_methods.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_records = cur.fetchall()
                        print("existing records: " + str(existing_records))

                        cur.nextset()
                        new_references = cur.fetchall()
                        print("new references: " + str(new_references))

                        if(len(new_references) > 0):
                            raise ValueError(f"The following references do not exist in the database: {new_references}. Please add them to the reference table before uploading new stratum methods.")

                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_method/insert_stratum_methods_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
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

                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_type/create_stratum_type_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_type/insert_stratum_types_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, stratum_type_inputs)

                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_type/insert_stratum_types_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_stratum_type_records = cur.fetchall()
                        print("inserted stratum type records: " + str(inserted_stratum_type_records))

                        stratummethod_ids = []
                        for record in inserted_stratum_method_records:
                            stratummethod_ids.append(record['stratummethod_id'])
                        print("stratummethod_ids: " + str(stratummethod_ids))

                        print("about to run create accession code")
                        with open(self.QUERIES_FOLDER + "/stratum_method/stratum_method/create_stratum_method_accession_codes.sql", "r") as file:
                            sql = file.read()
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
