import os
import io
import re
import textwrap
from flask import jsonify, send_file
import psycopg
import pandas as pd
import numpy as np
import pyarrow as pa
import pyarrow.parquet as pq
import traceback
from psycopg import ClientCursor
from psycopg.rows import dict_row
from utilities import jsonify_error_message, QueryParameterError

table_code_lookup = {
    'community-classifications': 'cl',
    'community-concepts': 'cc',
    'community-interpretations': 'ci',
    'cover-methods': 'cm',
    'parties': 'py',
    'plant-concepts': 'pc',
    'plot-observations': 'ob',
    'projects': 'pj',
    'references': 'rf',
    'stratum-methods': 'sm',
    'taxon-interpretations': 'ti',
    'taxon-observations': 'to',
}


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
        ROOT_QUERIES_FOLDER (str): Root path where SQL query files are stored.
            This is for queries that are shared across multiple operators.
        QUERIES_FOLDER (str): Path where SQL query files are stored.
        detail_options (str): Accepted detail param values. This should
            be overridden by operator implementations as needed.
        default_detail (str): Default detail value.
        nested_options (str): Accepted with_nested param values. This should
            be overridden by operator implementations as needed.
        default_nested (str): Default with_nested value.
        default_create_parquet (str): Default create_parquet value.
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
        include_full_count (bool): If True, query the database and send the
            full count of records. If False, simply return the count of records
            in the response.
        debug (bool): If True, be more liberal about debugging output
        query_mode (str): Query execution mode, which is always initialized to
            'normal', but may be updated to an alternative value ('count',
            'sql_debug', or 'sql_debug_count') based on a combination of the
            client request and self.debug.
    """

    def __init__(self, params=None):
        """
        Initialize common default values for all operators. Several, including
        `name`, `table_code`, and `full_get_parameters`, must be overridden by
        child classes to reflect their specific resource and querying details.
        """
        self.ROOT_QUERIES_FOLDER = "queries/"
        self.QUERIES_FOLDER = "queries/"
        self.detail_options = ["full"]
        self.default_detail = "full"
        self.nested_options = ["false"]
        self.default_nested = "false"
        self.default_create_parquet = "false"
        self.default_limit = "1000"
        self.default_offset = "0"
        self.sort_options = ["default"]
        self.default_sort = "default"
        self.params = params
        self.name = "vegbank"
        self.table_code = "vb"
        self.full_get_parameters = None
        self.include_full_count = True
        self.debug = True
        self.query_mode = 'normal'

    def extract_id_from_vb_code(self, vb_code, table_code = None):
        """
        Parse the integer database ID from a vb_code string

        Verifies whether the vb_code matches the expected code string pattern,
        and if it does, extract and return the integer ID.

        Parameters:
            vb_code (str): A vb code (e.g., "pc.123")
        Returns:
            int: The extracted integer
        Raises:
            QueryParameterError: If any supplied code does not match the
                expected pattern.
        """
        if table_code is None:
             table_code = self.table_code
        vb_id_match = re.match(fr'^{table_code}\.(\d+)$', vb_code)
        if vb_id_match is None:
            raise QueryParameterError(
                f"Invalid {table_code} code '{vb_code}'."
            )
        return int(vb_id_match.group(1))

    def select_dict_to_sql(self, select_dict):
        select_list = []
        for alias, col in select_dict.items():
            if col == '*':
                select_list.append(alias)
            else:
                select_list.append(f"{col} AS {alias}")
        if '*' in select_dict:
            select_dict.pop('*')
        return 'SELECT ' + ',\n       '.join(select_list)

    def process_integer_param(self, param_name, param_value):
        err_msg = f"When provided, {param_name} must be a non-negative integer."
        try:
            param_value = int(param_value)
        except ValueError:
            raise QueryParameterError(err_msg)
        if param_value < 0:
            raise QueryParameterError(err_msg)
        return param_value

    def process_option_param(self, param_name, param_value, options):
        param_value = param_value.lower()
        # Retun the lower-cased parameter if its valid
        if param_value in options:
            return param_value
        # ... otherwise raise an informative error message
        q_options = [f"'{option}'" for option in options]
        if len(q_options) == 0:
            err_msg = f"Unhandled parameter '{param_name}'."
        else:
            if len(q_options) == 1:
                option_str = q_options[0]
            elif len(q_options) == 2:
                option_str = ' or '.join(q_options)
            elif 2 < len(q_options):
                option_str = f"{', '.join(q_options[:-1])}, or {q_options[-1]}"
            err_msg = f"When provided, '{param_name}' must be {option_str}."
        raise QueryParameterError(err_msg)

    def build_query(self, by=None, count=False, searching=False, sort=False,
                    paginating=False):
        """
        Helper method to construct the full SQL query for retrieving data

        Pieces together SQL from configuration bits, while building a correctly
        ordered list of names corresponding to placeholder values in the SQL
        statement.

        Parameters:
            by (str): A vb table code (e.g., "ob"), or None. Used to inject the
                relevant sql snippets for matching to a given record type.
            count (bool): Apply COUNT(1) rather than returning actual table
                fields? (default False)
            searching (bool): Inject fulltext search? (default False)
            sort (bool): Apply ORDER BY? (default False)
            paginating (bool): Apply LIMIT/OFFET? (default False)

        Returns:
            A tuple containing:
                - str: The full SQL statement with relevant placeholders (%s)
                - list of str: Expected parameter names corresponding to the
                    placeholders, in the correct order wrt the SQL statement
        """

        # Preliminaries
        args = locals().copy()
        del args['self']
        self.configure_query(**args)

        # Start with empty list of query placeholders, to be built out as we go
        params = []

        # Assemble and format base query. This will be wrapped in a leading CTE,
        # aliased with the name provided in self.query['base']['alias'].
        base = self.query.get('base')
        if base is None:
            base_sql = ""
        else:
            base_sql_parts = []
            # Prepare base SELECT block (and update params)
            if count:
                base_select_sql = "SELECT COUNT(1)"
            else:
                base_select = base.get('select')
                base_columns = base_select.get('always')['columns']
                params.extend(base_select.get('always')['params'])
                if (searching):
                    base_columns.update(base_select.get('search')['columns'])
                    params.extend(base_select.get('search')['params'])
                base_select_sql = self.select_dict_to_sql(base_columns)
            base_sql_parts.append(base_select_sql)

            # Prepare base FROM block (and update params)
            base_from = base.get('from')
            base_from_sql = textwrap.dedent(base_from['sql']).rstrip()
            base_from_sql = textwrap.indent(base_from_sql, '  ')
            base_sql_parts.append(base_from_sql)
            params.extend(base.get('from')['params'])

            # Load base WHERE (and update params)
            base_conditions = base.get('conditions', {})
            if base_conditions.get('always') is not None:
                base_condition_list = base_conditions.get('always')['sql']
                if not isinstance(base_condition_list, list):
                    base_condition_list = [base_condition_list]
                params.extend(base_conditions.get('always')['params'])
            else:
                base_condition_lists = []
            if by is not None:
                try:
                    base_by_conditions = base_conditions[by]
                except KeyError:
                    raise QueryParameterError(f"Invalid query term '{by}'.")
                base_condition_list.append(base_by_conditions['sql'])
                params.extend(base_by_conditions['params'])
            if (searching):
                base_search = base.get('search', {})
                base_condition_list.append(base_conditions.get('search')['sql'])
                params.extend(base_conditions.get('search')['params'])
            base_condition_list = list(filter(None, base_condition_list))
            base_condition_list = [textwrap.dedent(sql).rstrip() for
                                   sql in base_condition_list]
            base_where_sql = f"  WHERE {'\n    AND '.join(base_condition_list)}" \
                if base_condition_list else None
            base_sql_parts.append(base_where_sql)

            # Load ORDER BY clauses, if any (and update params)
            if count:
                order_by_sql = None
            else:
                order_by = base.get('order_by')
                order_by_sql = textwrap.dedent(order_by['sql']).rstrip()
                order_by_sql = textwrap.indent(order_by_sql, '  ')
                base_sql_parts.append(order_by_sql)
                params.extend(base.get('order_by')['params'])

            # Prep LIMIT and OFFSET, if paginating
            if (paginating):
                base_limits_sql = "  LIMIT %s OFFSET %s"
                params.extend(['limit', 'offset'])
            else:
                base_limits_sql = None
            base_sql_parts.append(base_limits_sql)

            # Construct the full base CTE
            base_sql = textwrap.indent(
                '\n'.join([block for block in base_sql_parts
                           if block is not None]), '  ')
            if (count):
                return base_sql, params
            base_sql = f"WITH {base.get('alias')} AS (\n{base_sql}\n)"

        # Assemble and format main query, which includes the following, in order:
        #  - Base CTE followed by any other CTEs
        #  - SELECT statement
        #  - FROM statement
        #  - WHERE clauses
        #  - ORDER BY (matching the order of the base CTE)
        main_sql_parts = []
        # Load additional CTEs (or really any other SELECT preamble), if any
        cte = self.query.get('cte')
        if cte is not None:
            cte_sql = base_sql.rstrip('\n') + \
                f", {cte.get('sql')}"
            params.extend(cte.get('params'))
        else:
            cte_sql = base_sql
        main_sql_parts.append(cte_sql)

        # Load SELECTs (and update params)
        # ... or instead construct a COUNT statement if appropriate
        if (count):
            main_select_sql = "SELECT COUNT(1)"
        else:
            select_dict = self.query.get('select')
            main_columns = select_dict.get('always')['columns']
            params.extend(select_dict.get('always')['params'])
            if (searching):
                main_columns.update(select_dict.get('search')['columns'])
                params.extend(select_dict.get('search')['params'])
            main_select_sql = self.select_dict_to_sql(main_columns)
        main_sql_parts.append(main_select_sql)

        # Load FROMs (and update params)
        main_from = self.query.get('from')
        main_from_sql = textwrap.dedent(main_from['sql']).rstrip()
        main_from_sql = textwrap.indent(main_from_sql, '  ')
        params.extend(self.query.get('from')['params'])
        main_sql_parts.append(main_from_sql)

        # Apply same ORDER BY as in the base CTE
        if not count and order_by_sql is not None:
            main_sql_parts.append(order_by_sql)
            params.extend(base.get('order_by')['params'])

        # Construct the full SQL statement
        sql = '\n'.join([block for block in main_sql_parts
                         if block is not None])

        # Return the SQL and associated ordered list of placeholder names
        return sql, params

    def get_vegbank_resources(self, request, vb_code=None):
        """
        Retrieve either an individual VegBank resource or a collection.

        If this is a single-resource query with a valid vb_code (i.e., prefix
        matches `self.table_code`), returns the corresponding record of type
        `self.name` if one exists.
            - E.g.: '/plot-observations/ob.123' returns plot observation ob.123

        If no vb_code is provided, returns the full collection of records with
        pagination, along with the full collection count.
            - Example: '/plot-observations' returns all plot observations

        If this is a cross-resource query with a valid vb_code for the scoping
        resource (i.e., prefix matches the table code derived from the query
        scope), returns the collection of target resource records associated
        with the scoping resource, again with pagination and a count of the
        (scoped) collection:
            - Example: '/projects/pj.456/plot-observations' returns all plot
              observations associated with project pj.456

        Parameters:
            request (flask.Request): The Flask request object containing query
                parameters.
            vb_code (str or None): The unique identifier for the VegBank
                resource being retrieved or for the resource used to scope the
                collection of resources being retrieved. If None, retrieves all
                records.

        Query Parameters:
            count (optional): If present, only return the collection count.
            detail (str, optional): Level of detail for the response.
                Can always be 'full', sometimes 'minimal'. Defaults to 'full'.
            with_nested (str, optional): Include nested fields?
                Can always be 'false', sometimes 'true'. Defaults to 'false'.
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
                  associated record count if provided
                - For invalid parameters: JSON error message with 400 status code
        """

        # Handle any requests to do something other than executing a full query
        sql_mode = request.args.get('sql') is not None
        count_mode = request.args.get('count') is not None

        if sql_mode and count_mode and self.debug:
            self.query_mode = 'sql_debug_count'
        elif sql_mode and self.debug:
            self.query_mode = 'sql_debug'
        elif count_mode:
            self.query_mode = 'count'
        else:
            self.query_mode = 'normal'

        # ** TEMPORARY -- WILL BE REMOVED IN THE NEAR FUTURE **
        # If an operator uses the "old style" logic or if we directly ask for it
        # in the API request, redirect to the old method for getting data
        if not hasattr(self, 'configure_query') or request.args.get('old') is not None:
            return self.get_vegbank_resources_old(request, vb_code)

        try:
            params = self.validate_query_params(request.args)
            self.detail = params['detail']
            self.with_nested = params['with_nested']
            self.order_by = params['sort']
            self.direction = params['direction']
        except QueryParameterError as e:
            return jsonify_error_message(e.message), e.status_code

        # Get the table code associated with the current query scope, which may
        # be different from the table code associated with the target resource
        # (defined by self.table_code).
        #
        # E.g., if the route is '/plot-observations', then the query scope and
        # target resource both use table code 'ob'. However, if the route is
        # `/projects/pj.123/plot-observations`, then the query scope is table
        # code `pj` (a project) even though the target resource is associated
        # with table code 'ob' (observations).
        resource_type = request.path.split('/')[1]
        table_code = table_code_lookup[resource_type]

        # Are we limiting our query of the target resource type (e.g., plot
        # observations) to records associated with a member of some other
        # resource type (e.g., a project)?
        is_cross_resource_query = table_code != self.table_code
        # Are we querying based on some specific vb_code?
        querying_by_code = vb_code is not None
        # Are we paginating? Yes whenever we might be pulling multiple records,
        # which is true except when querying a resource directly by its vb_code
        paginating = is_cross_resource_query or not querying_by_code
        # Are we sorting? Yes always, if we might pull multiple records
        sort = paginating
        # Are we searching? Yes if asked, unless we're getting a single record,
        # in which case *we will ignore the search condition*
        searching = (params.get('search') is not None) and paginating

        if querying_by_code:
            try:
                vb_id = self.extract_id_from_vb_code(vb_code, table_code)
            except QueryParameterError as e:
                return jsonify_error_message(e.message), e.status_code
            params['vb_id'] = vb_id
            by = table_code
        else:
            by = None

        sql, placeholders = self.build_query(by=by, searching=searching,
                                             paginating=paginating, sort=paginating)
        data = [params.get(val) for val in placeholders]

        using_record_count = querying_by_code and not is_cross_resource_query
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            # In sql_debug mode, just return the generated SQL
            if self.query_mode == 'sql_debug':
                with conn.cursor() as cur:
                    return cur.mogrify(sql, data)
            # Otherwise, deal with counting before proceeding to actual queries
            if not self.include_full_count:
                if self.query_mode == 'sql_debug_count':
                    return jsonify("/*-- No count performed --*/")
                # Setting to None means no count will be reported later
                count = None
                if self.query_mode == 'count':
                    return jsonify({'count': count})
            elif using_record_count:
                if self.query_mode == 'sql_debug_count':
                    return jsonify("/*-- Using actual record count --*/")
                # Setting to -1 means count will be based on actual record count
                count = -1
                if self.query_mode == 'count':
                    # Note: with query_mode set to 'count', this method will
                    # only query for and report counts, not the full data
                    return self.create_json_response(conn, sql, data, count)
            else:
                count_sql, placeholders = self.build_query(by=by, count=True,
                    searching=searching, sort=False)
                count_data = [params.get(val) for val in placeholders]
                if self.query_mode == 'sql_debug_count':
                    with conn.cursor() as cur:
                        return cur.mogrify(count_sql, count_data)
                # In this case, count is based on full record count
                with conn.cursor() as cur:
                    count = cur.execute(count_sql, count_data).fetchone()[0]
                if self.query_mode == 'count':
                    return jsonify({'count': count})
            # Now query for data (if we didn't already return SQL or a count),
            # passing in the count as set above to one of: the full count, -1 as
            # an indicator to use the record count, or None to skip counting
            if params['create_parquet']:
                return self.create_parquet_response(conn, sql, data, count)
            else:
                return self.create_json_response(conn, sql, data, count)

    def get_vegbank_resources_old(self, request, vb_code=None):
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
            # Prepare to query for a collection of resources
            # Load collection query string
            detail = params.get('detail', 'full')
            sql_file = os.path.join(self.QUERIES_FOLDER,
                                    f'get_{self.name}_{detail}.sql')
            with open(sql_file, "r") as file:
                sql = file.read()
            if (self.include_full_count):
                # Load collection count query string
                sql_file_count = os.path.join(self.QUERIES_FOLDER,
                                              f'get_{self.name}_count.sql')
                with open(sql_file_count, "r") as file:
                    count_sql = file.read()
            else:
                count_sql = None
            # Extract param values to pass to the database query, matching the
            # placeholders contained in the associated SQL statement
            if self.full_get_parameters is None:
                raise ValueError("The 'full_get_parameters' attribute must be set.")
            data = tuple(params[k] for k in self.full_get_parameters)
        else:
            # Prepare to query for a single resource based on its code
            try:
                vb_id = self.extract_id_from_vb_code(vb_code)
            except QueryParameterError as e:
                return jsonify_error_message(e.message), e.status_code
            # Load individual resource query string
            sql_file = os.path.join(self.QUERIES_FOLDER,
                                    f'get_{self.name}_by_id.sql')
            with open(sql_file, "r") as file:
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
            self.default_create_parquet).lower() == "true"

        params['detail'] = self.process_option_param('detail',
            request_args.get('detail', self.default_detail),
            self.detail_options)
        params['with_nested'] = self.process_option_param('with_nested',
            request_args.get('with_nested', self.default_nested),
            self.nested_options)
        params['limit'] = self.process_integer_param('limit',
            request_args.get('limit', self.default_limit))
        params['offset'] = self.process_integer_param('offset',
            request_args.get('offset', self.default_offset))

        sort = request_args.get('sort', self.default_sort)
        params['direction'] = 'ASC'
        if sort.startswith('+'):
            sort = sort[1:]
        elif sort.startswith('-'):
            sort = sort[1:]
            params['direction'] = 'DESC'
        params['sort'] = self.process_option_param('sort',
            sort, self.sort_options)

        return params

    def create_json_response(self, conn, sql, data, count=None):
        """
        Execute a database query and return results as a JSON response

        If count is None, no count will reported. If count is -1
        (sentinel value), the number of records in the query result set
        will be reported as the count. Otherwise, the provided count
        value will be reported along with the response. When reported,
        counts are provided as a top-level JSON element with key 'count'.

        Parameters:
            conn (psycopg.Connection): Active database connection.
            sql (str): Main SQL query to retrieve data records.
            data (tuple): Query parameters to be substituted into the SQL query.
            count (int): Total record count, or None if not available.

        Returns:
            flask.Response: A Flask JSON response containing:
                - data (list): List of database records as dictionaries
                - count (int): Total record count (from count or len(data)),
                      omitted if count is None
        """
        to_return = {}
        conn.row_factory = dict_row
        with conn.cursor() as cur:
            cur.execute(sql, data)
            results = cur.fetchall()
            if count == -1:
                count = len(results)
            if count is not None:
                to_return["count"] = count
            if self.query_mode == 'normal':
                to_return["data"] = results
        return jsonify(to_return)

    def create_parquet_response(self, conn, sql, data, count=None):
        """
        Execute a database query and return results as a Parquet response

        If count is None, no count will reported. If count is -1
        (sentinel value), the number of records in the query result set
        will be reported as the count. Otherwise, the provided count
        value will be reported along with the response. When reported,
        counts are embedded in Parquet as metadata with key 'vb_count'.

        Parameters:
            conn (psycopg.Connection): Active database connection.
            sql (str): Main SQL query to retrieve data records.
            data (tuple): Query parameters to be substituted into the SQL query.
            count (int): Full record count, or None if not available

        Returns:
            flask.Response: A Flask Parquet response containing the data,
                including with a custom metadata field with key 'vb_count'
                containing the reported record count (omitted if count is None)
        """
        with conn.cursor() as cur:
            df = pd.read_sql(cur.mogrify(sql, data), conn)
        if count is -1:
            count = len(df)
        arrow_tbl = pa.Table.from_pandas(df)
        if count is not None:
            arrow_tbl = arrow_tbl.replace_schema_metadata({'vb_count': str(count)})
        buffer = io.BytesIO()
        pq.write_table(arrow_tbl, buffer)
        buffer.seek(0)
        return send_file(buffer,
                         mimetype='application/octet-stream',
                         as_attachment=True,
                         download_name=f'{self.name}.parquet')

    def upload_to_table(self, insert_table_name, insert_table_code, insert_table_def, insert_table_id, df, create_codes, conn):
        """
        Execute a series of insert statements that upload data for a specified table.

        Parameters:
            insert_table_name (str): The name of the table to insert data into.
            insert_table_code (str): The two letter code prefix associated with the table.
            insert_table_def (list): List of column names expected in the DataFrame. 
                These are stored in table_defs_config.py. 
            df (pd.DataFrame): DataFrame containing the data to be inserted.
            create_codes (bool): Whether to create records in the identifier table for the new records.
            conn (psycopg.Connection): Active database connection. 
                Allows for multiple tables to be uploaded in a single transaction.

        Returns:
            flask.Response: A Flask JSON response containing:
                    - resources: pairs of user and vb codes for the new records
                    - counts: number of new records created
        """
        print(f"DataFrame loaded with {len(df)} records.")
        
        
        df.columns = df.columns.str.lower()
        table_df = df[df.columns.intersection(insert_table_def)]
        table_df = table_df.reindex(columns=insert_table_def)
        table_df = table_df.drop_duplicates()
        table_df.replace({pd.NaT: None, np.nan: None}, inplace=True)

        join_field_name = 'user_' + insert_table_code + '_code' 
        duplicate_user_codes = table_df[join_field_name].duplicated()
        if duplicate_user_codes.any():
            duplicated_codes = table_df.loc[duplicate_user_codes, join_field_name].tolist()
            raise ValueError(f"The following user codes are duplicated in the upload data for table {insert_table_name}: {duplicated_codes}")
        
        table_inputs = list(table_df.itertuples(index=False, name=None))
        with conn.cursor() as cur:
            sql_file_temp_table = os.path.join(self.QUERIES_FOLDER,
                                f'{insert_table_name}/create_{insert_table_name}_temp_table.sql')
            with open(sql_file_temp_table, "r") as file:
                sql = file.read()
            cur.execute(sql)
            sql_file_temp_insert = os.path.join(self.QUERIES_FOLDER,
                                f'{insert_table_name}/insert_{insert_table_name}_to_temp_table.sql')
            with open(sql_file_temp_insert, "r") as file:
                sql = file.read()
            cur.executemany(sql, table_inputs)
            sql_file_validate = os.path.join(self.QUERIES_FOLDER,
                                f'{insert_table_name}/validate_{insert_table_name}.sql')
            with open(sql_file_validate, "r") as file:
                sql = file.read()
            cur.execute(sql)
            validation_results = cur.fetchall()
            while cur.nextset():
                next_validation = cur.fetchall()
                if next_validation:
                    validation_results = validation_results + next_validation
            validation_results_list = [dict(t) for t in {tuple(d.items()) for d in validation_results}]
            if validation_results:
                raise ValueError(f"The following vb codes do not exist in vegbank: {validation_results_list}")

            sql_file_insert = os.path.join(self.QUERIES_FOLDER,
                                f'{insert_table_name}/insert_{insert_table_name}.sql')
            with open(sql_file_insert, "r") as file:
                sql = file.read()
            cur.execute(sql)
            id_pairs = cur.fetchall()
            id_pairs_df = pd.DataFrame(id_pairs)

            new_codes_list = id_pairs_df[insert_table_id].tolist()

            joined_df = pd.merge(table_df, id_pairs_df, on=join_field_name)
            
            new_codes_df = pd.DataFrame()
            new_codes_df['vb_record_id'] = new_codes_list
            new_codes_df['vb_table_code'] = insert_table_code
            new_codes_df['identifier_type'] = 'vb_code'
            new_codes_df['identifier_value'] = insert_table_code + '.' + new_codes_df['vb_record_id'].astype(str)

            code_inputs = list(new_codes_df.itertuples(index=False, name=None))

            if create_codes:
                sql_file_create_codes = os.path.join(self.ROOT_QUERIES_FOLDER, 'create_codes.sql')
                with open(sql_file_create_codes, "r") as file:
                    sql = file.read()
                cur.executemany(sql, code_inputs, returning=True)
                new_identifiers = cur.fetchall()
                while cur.nextset():
                    next_identifiers = cur.fetchall()
                    if next_identifiers:
                        new_identifiers = new_identifiers + next_identifiers

            vb_field_name = f'vb_{insert_table_code}_code'
            to_return = {}
            to_return_entity = []
            for index, record in joined_df.iterrows():
                to_return_entity.append({
                    join_field_name: record[join_field_name], 
                    vb_field_name: record[vb_field_name],
                    "action":"inserted"
                })
            to_return["resources"] = {
                insert_table_code: to_return_entity
            }
            to_return["counts"] = {
                insert_table_code: {
                    "inserted":len(new_codes_list)
                } 
            }

            return to_return
