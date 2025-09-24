from flask import jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import io
import time
import operators.table_defs_config as table_defs_config
import traceback
from operators.operator_parent_class import Operator
from utilities import jsonify_error_message, convert_to_parquet, allowed_file

class StratumMethod(Operator):
    def __init__(self):
        super().__init__()

    def get_stratum_method(self, request, params, accession_code):
        """
        Retrieve stratum methods and stratum types based on the provided parameters.
        Parameters:
            request (Request): The request object containing query parameters.
            params (dict): Database connection parameters.
            accession_code (str or None): The accession code to filter the stratum method. 
                                           If None, retrieves all stratum methods and their types.
        Returns:
            Response: A JSON response containing the stratum methods data and count.
                      If 'detail' is specified, it can be either 'minimal' or 'full'.
                      Returns an error message with a 400 status code for invalid parameters.
        Raises:
            ValueError: If 'limit' or 'offset' are not non-negative integers.
        """

        create_parquet = request.args.get("create_parquet", "false").lower() == "true"
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
        
        with open(self.QUERIES_FOLDER + "/stratum_method/get_stratum_methods_count.sql", "r") as file:
            count_sql = file.read()

        if accession_code is not None:
            sql = open(self.QUERIES_FOLDER + "/stratum_method/get_stratum_method_by_accession_code.sql", "r").read()
            data = (accession_code, )
        else:
            data = (limit, offset, )
            with open(self.QUERIES_FOLDER + "/stratum_method/get_stratum_methods_full.sql", "r") as file:
                sql = file.read()
        
        to_return = {}
        with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
            if(create_parquet is False):
                conn.row_factory=dict_row
            else:
                print("about to make stratum method parquet file")
                df_parquet = convert_to_parquet(sql, data, conn)
                print(df_parquet)
                conn.close()
                return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='stratum_methods.parquet')
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()

                if accession_code is None:
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
            conn.close()   
        return jsonify(to_return)
    
    def upload_stratum_method(self, request, params):
        """
        Uploads stratum method and stratum type data from a file, validates it, and inserts it into the database.
        Parameters:
            request (Request): The incoming request containing the file to be uploaded.
            params (dict): Database connection parameters.
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
