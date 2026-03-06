import os
import pandas as pd
import numpy as np
import traceback
import psycopg
from vegbank.operators.operator_parent_class import Operator
from vegbank.operators import table_defs_config
from vegbank.utilities import jsonify_error_message, allowed_file, QueryParameterError, load_sql, validate_required_and_missing_fields, merge_vb_codes, combine_json_return
from flask import jsonify
from psycopg import ClientCursor
from psycopg.rows import dict_row


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
        config_cover_method = table_defs_config.cover_method[:]
        config_cover_index = table_defs_config.cover_index[:]
        table_defs = [config_cover_method, config_cover_index]
        required_fields = ['user_cm_code', 'covertype']
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
