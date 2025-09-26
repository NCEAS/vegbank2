import io
from flask import jsonify, send_file
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
from utilities import convert_to_parquet

class Operator:
    """
    Parent class for operators to inherit from and define common default values.

    This class provides a base implementation for database operators that handle
    SQL queries and response formatting.

    Attributes:
        QUERIES_FOLDER (str): Path where SQL query files are stored
        default_detail (str): Default detail level for responses
        default_limit (str): Default limit for number of records to return
        default_offset (str): Default offset for number of records to skip
        params (dict or None): Database connection parameters containing
            dbname, user, host, port, and password
        name (str): Name used for SQL file load paths and returned file names
    """

    def __init__(self, params=None):
        """
        Initialize common default values for all operators.

        Parameters:
            params (dict, optional): Database connection parameters.
                Expected to contain: dbname, user, host, port, password.
                Defaults to None.
        """
        self.QUERIES_FOLDER = "queries/"
        self.default_detail = "full"
        self.default_limit = 1000
        self.default_offset = 0
        self.params = params
        self.name = "vegbank"

    def create_json_response(self, sql, data, count_sql):
        """
        Execute a database query and return results as a JSON response

        If count_sql is provided, an additional query will be executed to
        obtain a record count along with the actual data records.

        Parameters:
            sql (str): Main SQL query to retrieve data records.
            data (tuple): Query parameters to be substituted into the SQL query.
            count_sql (str or None): Optional SQL query to count total records.
                If None, count is determined from the length of returned data.

        Returns:
            flask.Response: A Flask JSON response containing:
                - data (list): List of database records as dictionaries
                - count (int): Total record count (from count_sql or len(data))
        """
        to_return = {}
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            conn.row_factory = dict_row
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()
                if count_sql is not None:
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
        return jsonify(to_return)

    def create_parquet_response(self, sql, data):
        """
        Execute a database query and return results as a Parquet response

        Parameters:
            sql (str): Main SQL query to retrieve data records.
            data (tuple): Query parameters to be substituted into the SQL query.

        Returns:
            flask.Response: A Flask Parquet response containing the data
        """
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            df_parquet = convert_to_parquet(sql, data, conn)
        return send_file(io.BytesIO(df_parquet),
                         mimetype='application/octet-stream',
                         as_attachment=True,
                         download_name=f'{self.name}.parquet')
