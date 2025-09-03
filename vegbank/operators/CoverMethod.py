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

class CoverMethod(Operator):
    def __init__(self):
        super().__init__()

    def get_cover_method(self, request, params, accession_code):
        create_parquet = request.args.get("create_parquet", "false").lower() == "true"
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
        
        with open(self.QUERIES_FOLDER + "/cover_method/get_cover_methods_count.sql", "r") as file:
            count_sql = file.read()

        if accession_code is not None:
            sql = open(self.QUERIES_FOLDER + "/cover_method/get_cover_method_by_accession_code.sql", "r").read()
            data = (accession_code, )
        else:
            data = (limit, offset, )
            with open(self.QUERIES_FOLDER + "/cover_method/get_cover_methods_full.sql", "r") as file:
                sql = file.read()
        
        to_return = {}
        with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
            if(create_parquet is False):
                conn.row_factory=dict_row
            else:
                print("about to make cover method parquet file")
                df_parquet = convert_to_parquet(sql, data, conn)
                print(df_parquet)
                conn.close()
                return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='cover_methods.parquet')
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
    
    def upload_cover_method(self, request, params):
        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

        cover_method_fields = table_defs_config.cover_method
        cover_index_fields = table_defs_config.cover_index

        to_return = {}

        try:
            df = pd.read_parquet(file)
            print(f"DataFrame loaded with {len(df)} records.")

            df.columns = map(str.lower, df.columns)
            #Checking if the user submitted any unsupported columns
            additional_columns = set(df.columns) - set(cover_method_fields) - set(cover_index_fields)
            if(len(additional_columns) > 0):
                return jsonify_error_message(f"Your data must only contain fields included in the plot observation schema. The following fields are not supported: {additional_columns} ")

            df.replace({pd.NaT: None}, inplace=True)
            inputs = list(df.itertuples(index=False, name=None))

            with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
                
                with conn.cursor() as cur:
                    with conn.transaction():
                        
                        with open(self.QUERIES_FOLDER + "/cover_method/create_cover_method_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/cover_method/insert_cover_methods_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, inputs)

                        print("about to run validate cover methods")
                        with open(self.QUERIES_FOLDER + "/cover_method/validate_cover_methods.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_records = cur.fetchall()
                        print("existing records: " + str(existing_records))

                        with open(self.QUERIES_FOLDER + "/cover_method/insert_cover_methods_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_records = cur.fetchall()
                        print("inserted records: " + str(inserted_records))

                        covermethod_ids = []
                        for record in inserted_records:
                            covermethod_ids.append(record['covermethod_id'])
                        print("covermethod_ids: " + str(covermethod_ids))

                        print("about to run create accession code")
                        with open(self.QUERIES_FOLDER + "/cover_method/create_cover_method_accession_codes.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql, (covermethod_ids, ))
                        new_cm_codes = cur.fetchall()

                        cm_codes_df = pd.DataFrame(new_cm_codes)
                        print("cm_codes_df" + str(cm_codes_df))
                        df['covertype'] = df['covertype'].astype(str)
                        cm_codes_df['covertype'] = cm_codes_df['covertype'].astype(str)

                        joined_df = pd.merge(df, cm_codes_df, on='covertype')
                        print("----------------------------------------")
                        print(str(joined_df))


                        to_return_cover_methods = []
                        for index, record in joined_df.iterrows():
                            to_return_cover_methods.append({
                                "user_code": record['user_code'], 
                                "cm_code": record['cm_code'],
                                "covertype": record['covertype'],
                                "action":"inserted"
                            })
                        for record in existing_records:
                            to_return_cover_methods.append({
                                "user_code": record["user_code"],
                                "cm_code": record['user_code'],
                                "covertype": record['covertype'],
                                "action":"matched"
                            })
                        to_return["resources"] = {
                            "cm": to_return_cover_methods
                        }
                        to_return["counts"] = {
                            "cm":{
                                "inserted": len(joined_df),
                                "matched": len(existing_records)
                            }
                        }
                        
            conn.close()      

            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500
