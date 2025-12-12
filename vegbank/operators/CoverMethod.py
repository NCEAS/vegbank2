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
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
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
            'rf_name': "rf.shortname",
        }
        main_columns['full_nested'] = main_columns['full'] | {
            'cover_indexes': "cv.cover_indexes",
        }
        from_sql = {}
        from_sql['full'] = """\
            FROM cm
            LEFT JOIN reference rf USING (reference_id)
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

    def upload_cover_method(self, request, params):
        """
        Uploads cover method and cover index data from a file, validates it, and inserts it into the database.
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
                        exist in the database, or if there are no new cover methods to insert.
        """
        
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
            df.replace({np.nan: None}, inplace=True)

            cover_method_df = df[cover_method_fields]
            cover_method_df = cover_method_df.drop_duplicates()

            print(str(cover_method_df))
            print("---------------")
            cover_method_inputs = list(cover_method_df.itertuples(index=False, name=None))
            

            with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
                
                with conn.cursor() as cur:
                    with conn.transaction():
                        
                        with open(self.QUERIES_FOLDER + "/cover_method/cover_method/create_cover_method_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/cover_method/cover_method/insert_cover_methods_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, cover_method_inputs)
                        
                        print("about to run validate cover methods")
                        with open(self.QUERIES_FOLDER + "/cover_method/cover_method/validate_cover_methods.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        existing_records = cur.fetchall()
                        print("existing records: " + str(existing_records))

                        cur.nextset()
                        new_references = cur.fetchall()
                        print("new references: " + str(new_references))

                        if(len(new_references) > 0):
                            raise ValueError(f"The following references do not exist in the database: {new_references}. Please add them to the reference table before uploading new cover methods.")

                        with open(self.QUERIES_FOLDER + "/cover_method/cover_method/insert_cover_methods_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_cover_method_records = cur.fetchall()
                        print("inserted records: " + str(inserted_cover_method_records))

                        if(len(inserted_cover_method_records) == 0 and len(existing_records) == 0):
                            raise ValueError("No new cover methods to insert. Please check your data for duplicates.")
                        
                        inserted_cover_method_records_df = pd.DataFrame(inserted_cover_method_records)
                        print("inserted_cover_method_records_df: " + str(inserted_cover_method_records_df))

                        cover_index_df = pd.merge(df, inserted_cover_method_records_df[['covertype', 'covermethod_id']], on='covertype')
                        cover_index_df = cover_index_df[cover_index_fields]
                        cover_index_inputs = list(cover_index_df.itertuples(index=False, name=None))

                        with open(self.QUERIES_FOLDER + "/cover_method/cover_index/create_cover_index_temp_table.sql", "r") as file:
                            sql = file.read() 
                        cur.execute(sql)
                        with open(self.QUERIES_FOLDER + "/cover_method/cover_index/insert_cover_indices_to_temp_table.sql", "r") as file:
                            sql = file.read()
                        cur.executemany(sql, cover_index_inputs)

                        with open(self.QUERIES_FOLDER + "/cover_method/cover_index/insert_cover_indices_from_temp_table_to_permanent.sql", "r") as file:
                            sql = file.read()
                        cur.execute(sql)
                        inserted_cover_index_records = cur.fetchall()
                        print("inserted cover index records: " + str(inserted_cover_index_records))

                        covermethod_ids = []
                        for record in inserted_cover_method_records:
                            covermethod_ids.append(record['covermethod_id'])
                        print("covermethod_ids: " + str(covermethod_ids))

                        print("about to run create accession code")
                        with open(self.QUERIES_FOLDER + "/cover_method/cover_method/create_cover_method_accession_codes.sql", "r") as file:
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
                        to_return_cover_indices = []
                        for index, record in joined_df.iterrows():
                            to_return_cover_methods.append({
                                "user_code": record['user_code'], 
                                "cm_code": record['accessioncode'],
                                "covertype": record['covertype'],
                                "action":"inserted"
                            })
                        for record in inserted_cover_index_records:
                            print("record: " + str(record))
                            to_return_cover_indices.append({
                                "cm_code": "cm." + str(record['covermethod_id']), 
                                "ci_code": "ci." + str(record['coverindex_id']),
                                "covercode": record['covercode'],
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
                            "cm": to_return_cover_methods,
                            "ci": to_return_cover_indices
                        }
                        to_return["counts"] = {
                            "cm":{
                                "inserted": len(joined_df),
                                "matched": len(existing_records)
                            },
                            "ci":{
                                "inserted": len(inserted_cover_index_records)
                            }
                        }
            conn.close()      

            return jsonify(to_return)
        except Exception as e:
            traceback.print_exc()
            return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500
