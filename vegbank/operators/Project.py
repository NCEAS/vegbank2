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


class Project(Operator):
    def __init__(self):
        super().__init__()
        
    
    def get_projects(self, request, params, accession_code):
        create_parquet = request.args.get("create_parquet", "false").lower() == "true"
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

        with open(self.QUERIES_FOLDER + "/project/get_projects_count.sql", "r") as file:
            count_sql = file.read()

        sql = ""
        if(accession_code is None): 
            with open(self.QUERIES_FOLDER + "/project/get_projects_full.sql", "r") as file:
                sql = file.read()
            data = (limit, offset, )
        else:
            with open(self.QUERIES_FOLDER + "/project/get_project_by_accession_code.sql", "r") as file:
                sql = file.read()
            data = (accession_code, )
        to_return = {}
        with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
            if(create_parquet is False):
                conn.row_factory=dict_row
            else:
                df_parquet = convert_to_parquet(sql, data, conn)
                conn.close()
                return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='projects.parquet')
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()

                if(accession_code is None):
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
            conn.close()    
        return jsonify(to_return)

    def upload_project(self, request, params):
        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400
        
        project_fields = table_defs_config.project
        to_return = {}

        try:
            df = pd.read_parquet(file)
            print(f"DataFrame loaded with {len(df)} records.")

            df.columns = map(str.lower, df.columns)
            #Checking if the user submitted any unsupported columns
            additional_columns = set(df.columns) - set(project_fields)
            if(len(additional_columns) > 0):
                return jsonify_error_message(f"Your data must only contain fields included in the project schema. The following fields are not supported: {additional_columns} ")

            df.replace({pd.NaT: None}, inplace=True)
            df.replace({np.nan: None}, inplace=True)
            
            project_df = df[project_fields]

            inputs = list(project_df.itertuples(index=False, name=None))

            with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
                
                with conn.cursor() as cur:
                    with conn.transaction():
                        
                        with open(self.QUERIES_FOLDER + "/project/create_project_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/project/insert_projects_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, inputs)

                        print("about to run validate projects")
                        with open(self.QUERIES_FOLDER + "/project/validate_projects.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_records = cur.fetchall()
                        print("existing records: " + str(existing_records))

                        with open(self.QUERIES_FOLDER + "/project/insert_projects_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_records = cur.fetchall()
                        print("inserted records: " + str(inserted_records))

                        project_ids = []
                        for record in inserted_records:
                            project_ids.append(record['project_id'])
                        print("project_ids: " + str(project_ids))

                        print("about to run create accession code")
                        with open(self.QUERIES_FOLDER + "/project/create_project_accession_codes.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql, (project_ids, ))
                        new_pj_codes = cur.fetchall()

                        pj_codes_df = pd.DataFrame(new_pj_codes)
                        print("pj_codes_df" + str(pj_codes_df))
                        df['projectname'] = df['projectname'].astype(str)
                        pj_codes_df['projectname'] = pj_codes_df['projectname'].astype(str)
                        print("project name type: " + str(df['projectname'].dtype))
                        print("pj_code project name type: " + str(pj_codes_df['projectname'].dtype))

                        joined_df = pd.merge(df, pj_codes_df, on='projectname')
                        print("----------------------------------------")
                        print(str(joined_df))


                        to_return_projects = []
                        for index, record in joined_df.iterrows():
                            to_return_projects.append({
                                "user_code": record['pj_code'], 
                                "pj_code": record['accessioncode'],
                                "projectname": record['projectname'],
                                "action":"inserted"
                            })
                        for record in existing_records:
                            to_return_projects.append({
                                "user_code": record["pj_code"],
                                "pj_code": record['pj_code'],
                                "projectname": record['projectname'],
                                "action":"matched"
                            })
                        to_return["resources"] = {
                            "pj": to_return_projects
                        }
                        to_return["counts"] = {
                            "pj":{
                                "inserted": len(joined_df),
                                "matched": len(existing_records)
                            }
                        }
            conn.close()      

            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500
