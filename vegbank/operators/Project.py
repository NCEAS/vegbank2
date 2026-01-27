import os
from flask import jsonify
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import traceback
from operators import Operator, table_defs_config
from utilities import jsonify_error_message, allowed_file, QueryParameterError, validate_required_and_missing_fields


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
        self.sort_options = ["default", "project_name", "obs_count"]
        self.required_fields = {
            "projects": ['user_pj_code', 'project_name']
        }
        self.table_defs = {
            "projects": [table_defs_config.project]
        }
        

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
        order_by_sql = {}
        order_by_sql['default'] = f"""\
            ORDER BY project_id {self.direction}
            """
        order_by_sql['project_name'] = f"""\
            ORDER BY projectname {self.direction},
                     project_id {self.direction}
            """
        order_by_sql['obs_count'] = f"""\
            ORDER BY d_obscount {self.direction},
                     project_id {self.direction}
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
                'sql': order_by_sql[self.order_by],
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

    def upload_project(self, df, conn):
        """
        takes a parquet file of projects and uploads it to the project table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing projects.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        required_fields = ['user_pj_code', 'project_name']
        table_defs = [table_defs_config.project]
        validation = validate_required_and_missing_fields(df, required_fields, table_defs, "projects")
        if validation['has_error']:
            raise ValueError(validation['error'])

        df['user_pj_code'] = df['user_pj_code'].astype(str) # Ensure user_ti_codes are strings for consistent merging
        new_projects =  super().upload_to_table("project", 'pj', table_defs_config.project, 'project_id', df, True, conn, validate=False)
        return new_projects