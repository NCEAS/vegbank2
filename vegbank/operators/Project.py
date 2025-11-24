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


class Project(Operator):
    """
    Defines operations related to the exchange of project details with VegBank.

    Project: The project or study established to collect vegetation plot data.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "project"
        self.table_code = "pj"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(pj.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'pj_code': "'pj.' || project_id",
            'project_name': "projectname",
            'project_description': "projectdescription",
            'start_date': "startdate",
            'stop_date': "stopdate",
            'obs_count': "d_obscount",
            'last_plot_added_date': "d_lastplotaddeddate",
        }
        from_sql = "FROM pj"
        order_by_sql = """\
            ORDER BY projectname,
                     project_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "pj",
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
                'sql': "FROM project AS pj",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                'search': {
                    'sql': """\
                         pj.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                    """,
                    'params': ['search']
                },
                "pj": {
                    'sql': "pj.project_id = %s",
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
            'search': {
                'columns': {'search_rank': 'pj.search_rank'},
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

        This only applies validations specific to projects, then dispatches
        to the parent validation method for more general (and more permissive)
        validations.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # specifically require detail to be "full" for cover methods
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        return params


    def upload_project(self, request, params):
        """
        Uploads project data from a file, validates it, and inserts it into the database.
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
                        exist in the database, or if there are no new projects to insert.
        """

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
