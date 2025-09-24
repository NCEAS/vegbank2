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


class CommunityConcept(Operator):
    '''
    Defines operations related to Community Concept and Community Usage data management, 
    including retrieval and upload functionalities.
    Community Concept: A definition of a vegetation community according to a linked reference.
    Community Usage: A particular name associated with a community concept, and the 
    effective dates, status, and system for that name. 

    Inherits from the Operator parent class to utilize common default values.
    '''
    def __init__(self):
        super().__init__()
    
    
    def get_community_concepts(self, request, params, accession_code):
        """
        Retrieve community concepts based on the provided accession code,
        or via the provided URL parameters. See definitions below.
        Parameters:
            request (Request): The request object containing query parameters.
            params (dict): Database connection parameters.
            Set via env variable in vegbankapi.py. Keys are: 
                dbname, user, host, port, password
            accession_code (str or None): The accession code to filter the community concepts. 
                                           If None, retrieves all concepts.
        URL Parameters:
            detail (str, optional): Level of detail for the response. 
                                    Only 'full' is defined for this method. Defaults to 'full'.
            limit (int, optional): Maximum number of records to return. Defaults to 1000.
            offset (int, optional): Number of records to skip before starting to return records. Defaults to 0.
        Returns:
            Response: A JSON response containing the community concepts data and count.
                      If 'detail' is specified, it can be either 'minimal' or 'full'.
                      Returns an error message with a 400 status code for invalid parameters.
        Raises:
            ValueError: If 'limit' or 'offset' are not non-negative integers.
        """

        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

        with open(self.QUERIES_FOLDER + "/community_concept/get_community_concepts_count.sql", "r") as file:
            count_sql = file.read()

        sql = ""
        if(accession_code is None): 
            with open(self.QUERIES_FOLDER + "/community_concept/get_community_concepts_full.sql", "r") as file:
                sql = file.read()
            data = (limit, offset, )
        else:
            with open(self.QUERIES_FOLDER + "/community_concept/get_community_concept_by_accession_code.sql", "r") as file:
                sql = file.read()
            data = (accession_code, )

        to_return = {}
        with psycopg.connect(**params, row_factory=dict_row) as conn:
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