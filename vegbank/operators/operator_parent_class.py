import os
import io
import re
from flask import jsonify, send_file
import psycopg
from psycopg import ClientCursor
from psycopg.rows import dict_row
from utilities import convert_to_parquet, jsonify_error_message, QueryParameterError

class Operator:
    """
    Generic operator responsible for interacting with the VegBank database

    Defines core attributes and methods for reading from and writing to the
    VegBank backend database system to satisfy client API requests. This parent
    class itself cannot be used to interact with VegBank data. Instead, it
    defines base functionality to be used and extended by child classes,
    each specialized for working with a particular type of VegBank resource.

    Core operator functionality includes:
        - Managing DB and resource configuration information
        - Defining default query parameters
        - Preparing and validating query parameters
        - Executing read queries and returning data as JSON
        - Executing read queries and returning data as Parquet

    Attributes:
        QUERIES_FOLDER (str): Path where SQL query files are stored.
        default_detail (str): Default detail level for responses.
        default_limit (str): Default limit for number of records to return.
            Used for paginating collection responses.
        default_offset (str): Default offset for number of records to skip.
            Used for paginating collection responses.
        params (dict): Database connection parameters.
        name (str): Simple name used in SQL file paths and returned file names.
        table_code (str): String code to be set for a specific resource
            type, serving as the `vb_code` prefix in the VegBank database.
        full_get_parameters (tuple): Names of query parameters to be passed to
            the full GET query, in the order of placeholders in the SQL file.
    """

    def __init__(self, params=None):
        """
        Initialize common default values for all operators. Several, including
        `name`, `table_code`, and `full_get_parameters`, must be overridden by
        child classes to reflect their specific resource and querying details.
        """
        self.QUERIES_FOLDER = "queries/"
        self.default_detail = "full"
        self.default_limit = "1000"
        self.default_offset = "0"
        self.params = params
        self.name = "vegbank"
        self.table_code = "vb"
        self.full_get_parameters = None

    def get_vegbank_resources(self, request, vb_code=None):
        """
        Retrieve either an individual VegBank resource or a collection.

        If a valid vb_code is provided with prefix matching `self.table_code`,
        returns the corresponding record of type `self.name` if one exists. If
        no vb_code is provided, returns the full collection of records with
        pagination and field scope controlled by query parameters.

        Parameters:
            request (flask.Request): The Flask request object containing query
                parameters.
            vb_code (str or None): The unique identifier for the VegBank
                resource being retrieved. If None, retrieves all records.

        Query Parameters:
            detail (str, optional): Level of detail for the response.
                Can be either 'minimal' or 'full'. Defaults to 'full'.
            limit (int, optional): Maximum number of records to return.
                Defaults to 1000.
            offset (int, optional): Number of records to skip before starting
                to return records. Defaults to 0.
            create_parquet (str, optional): Whether to return data as Parquet
                rather than JSON. Accepts 'true' or 'false' (case-insensitive).
                Defaults to 'false'.
            ... Subclasses may provide additional parameters.

        Returns:
            flask.Response: A Flask response object containing:
                - For individual records: Data as JSON or Parquet
                - For collection records: Data as JSON or Parquet, with
                  associated record count if JSON
                - For invalid parameters: JSON error message with 400 status code
        """
        try:
            params = self.validate_query_params(request.args)
        except QueryParameterError as e:
            return jsonify_error_message(e.message), e.status_code

        if vb_code is None:
            # Prepare to query for the full collection
            sql_file_full = os.path.join(self.QUERIES_FOLDER,
                                         f'get_{self.name}_full.sql')
            with open(sql_file_full, "r") as file:
                sql = file.read()
            sql_file_count = os.path.join(self.QUERIES_FOLDER,
                                          f'get_{self.name}_count.sql')
            with open(sql_file_count, "r") as file:
                count_sql = file.read()
            if self.full_get_parameters is None:
                raise ValueError("The 'full_get_parameters' attribute must be set.")
            # Extract param values to pass to the database query, matching the
            # placeholders contained in the associated SQL statement
            data = tuple(params[k] for k in self.full_get_parameters)
        else:
            # Prepare to query for a single resource based on its code
            #
            # Verify that the vb_code matches the expected code string pattern,
            # and if so, extract the table primary key to use in the query
            vb_id_match = re.match(fr'^{self.table_code}\.(\d+)$', vb_code)
            if vb_id_match is None:
                return (
                    jsonify_error_message(f"Invalid {self.name} code '{vb_code}'."),
                    400
                )
            else:
                vb_id = int(vb_id_match.group(1))
            sql_file_by_id = os.path.join(self.QUERIES_FOLDER,
                                          f'get_{self.name}_by_id.sql')
            with open(sql_file_by_id, "r") as file:
                sql = file.read()
            count_sql = None
            data = (vb_id, )

        if params['create_parquet']:
            return self.create_parquet_response(sql, data)
        else:
            return self.create_json_response(sql, data, count_sql)

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        Checks that all provided parameters have correct types and values within
        acceptable ranges. Missing parameters are set to their default values.

        Parameters:
            request_args (dict or ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.

        Example:
            >>> args = ImmutableMultiDict([('limit', '10')])
            >>> result = self.validate_query_params(args)
            >>> result
            {'limit': 10, 'offset': 0, 'detail': 'full'}
        """
        params = {}
        params['create_parquet'] = request_args.get("create_parquet",
                                                    "false").lower() == "true"
        params['detail'] = request_args.get("detail", self.default_detail)
        if params['detail'] not in ("minimal", "full"):
            raise QueryParameterError(
                "When provided, 'detail' must be 'minimal' or 'full'."
            )
        try:
            params['limit'] = int(request_args.get("limit",
                                                   self.default_limit))
            params['offset'] = int(request_args.get("offset",
                                                    self.default_offset))
        except ValueError:
            raise QueryParameterError(
                "When provided, 'offset' and 'limit' must be non-negative integers."
            )
        if params['limit'] < 0 or params['offset'] < 0:
            raise QueryParameterError(
                "When provided, 'offset' and 'limit' must be non-negative integers."
            )
        return params

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
