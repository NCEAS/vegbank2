import io
from flask import jsonify, send_file
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
from utilities import convert_to_parquet

class Operator:
    '''
    A super class for all operators to inherit from and define common default values.
    Attributes:
        QUERIES_FOLDER: str: The folder path where SQL query files are stored.
        default_detail: str: The default detail level for responses, set to "full".
        default_limit: str: The default limit for number of records to return, set to "1000".
        default_offset: str: The default offset for number of records to skip, set to "0".
        params: dict: Database connection parameters.
        name: str: Simple name used for SQL file load paths and returned file names.
    '''

    def __init__(self, params=None):
        '''
        Initialize common default values for all operators.
        '''
        self.QUERIES_FOLDER = "queries/"
        self.default_detail = "full"
        self.default_limit = "1000"
        self.default_offset = "0"
        self.params = params
        self.name = "vegbank"

    def create_json_response(self, sql, data, count_sql):
        to_return = {}
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            conn.row_factory=dict_row
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()
                if count_sql is not None:
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
            conn.close()
        return jsonify(to_return)

    def create_parquet_response(self, sql, data):
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            df_parquet = convert_to_parquet(sql, data, conn)
        return send_file(io.BytesIO(df_parquet),
                         mimetype='application/octet-stream',
                         as_attachment=True,
                         download_name=f'{self.name}.parquet')