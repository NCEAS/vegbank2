import os
import re
from operators import Operator
from utilities import jsonify_error_message, QueryParameterError


class PlantConcept(Operator):
    '''
    Defines operations related to the exchange of plant concept data with
    Vegbank, including usage and status (party perspective) information.

    Plant Concept: A definition of a named plant taxon according to a reference.
    Plant Usages: Particular names associated with a plant concept, and the
    effective dates, status, and system for that name.
    Plant Status: The asserted status of a concept, according to a party
    (a.k.a., a party perspective).

    Inherits from the Operator parent class to utilize common default values.
    '''

    def __init__(self, params):
        super().__init__(params)
        self.name = "plant_concept"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        Checks that all provided parameters have correct types and values within
        acceptable ranges. Missing parameters are set to their default values.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
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
        params['create_parquet'] = request_args.get("create_parquet", "false").lower() == "true"
        params['detail'] = request_args.get("detail", self.default_detail)
        if params['detail'] not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")
        try:
            params['limit'] = int(request_args.get("limit", self.default_limit))
            params['offset'] = int(request_args.get("offset", self.default_offset))
        except ValueError:
            raise QueryParameterError("When provided, 'offset' and 'limit' must be non-negative integers.")
        if params['limit'] < 0 or params['offset'] < 0:
            raise QueryParameterError("When provided, 'offset' and 'limit' must be non-negative integers.")
        return params

    def get_plant_concepts(self, request, pc_code):
        """
        Retrieve either an individual plant concept or a collection.

        If a valid pc_code is provided, returns the corresponding record if it
        exists. If no pc_code is provided, returns the full collection of
        concept records with pagination and field scope controlled by query
        parameters.

        Parameters:
            request (flask.Request): The Flask request object containing query
                parameters.
            pc_code (str or None): The unique identifier for the plant concept
                being retrieved. If None, retrieves all plant concepts.

        Query Parameters:
            detail (str, optional): Level of detail for the response.
                Only 'full' is defined for this method. Defaults to 'full'.
            limit (int, optional): Maximum number of records to return.
                Defaults to 1000.
            offset (int, optional): Number of records to skip before starting
                to return records. Defaults to 0.
            create_parquet (str, optional): Whether to return data as Parquet
                rather than JSON. Accepts 'true' or 'false' (case-insensitive).
                Defaults to False.

        Returns:
            flask.Response: A Flask response object containing:
                - For individual concepts: Plant concept data as JSON or Parquet
                - For collection concepts: Plant concept data as JSON or Parquet,
                  with associated record count if JSON
                - For invalid parameters: JSON error message with 400 status code
        """

        try:
            params = self.validate_query_params(request.args)
        except QueryParameterError as e:
            return jsonify_error_message(e.message), e.status_code

        if pc_code is None:
            with open(os.path.join(self.QUERIES_FOLDER, "get_plant_concepts_full.sql"), "r") as file:
                sql = file.read()
            with open(os.path.join(self.QUERIES_FOLDER, "get_plant_concepts_count.sql"), "r") as file:
                count_sql = file.read()
            data = (params['limit'], params['offset'], )
        else:
            pc_id_match = re.match(r'^pc\.(\d+)$', pc_code)
            if pc_id_match is None:
                return jsonify_error_message(f"Invalid plant concept code '{pc_code}'."), 400
            else:
                pc_id = int(pc_id_match.group(1))
            with open(os.path.join(self.QUERIES_FOLDER, "get_plant_concept_by_pc_code.sql"), "r") as file:
                sql = file.read()
            count_sql = None
            data = (pc_id, )

        if params['create_parquet']:
            return self.create_parquet_response(sql, data)
        else:
            return self.create_json_response(sql, data, count_sql)
