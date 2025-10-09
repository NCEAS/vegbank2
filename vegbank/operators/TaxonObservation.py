from flask import jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import os
import operators.table_defs_config as table_defs_config
import traceback
from operators.operator_parent_class import Operator
from utilities import jsonify_error_message, convert_to_parquet, allowed_file

class TaxonObservation(Operator):
    '''
    Defines operations related to Taxon Observation data management, 
    including retrieval and upload functionalities.
    Taxon Observation: A record of a plant observed on a particular plot observation. 
    A single taxon observation can have many taxon interpretations. 

    Inherits from the Operator parent class to utilize common default values.
    '''

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_observation"
        self.table_code = "to"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def get_taxon_observations(self, request, params, accession_code):
        """
        Retrieve taxon observations based on the provided accession code,
        or via the provided URL parameters. See definitions below.
        Parameters:
            request (Request): The request object containing query parameters.
            params (dict): Database connection parameters.
            Set via env variable in vegbankapi.py. Keys are: 
                dbname, user, host, port, password
            accession_code (str or None): The unique identifier for the taxon observation being retrieved.
                                           If None, retrieves all taxon observations and their top taxa.
        URL Parameters:
            detail (str, optional): Level of detail for the response. 
                                    Only 'full' is defined for this method. Defaults to 'full'.
            limit (int, optional): Maximum number of records to return. Defaults to 1000.
            offset (int, optional): Number of records to skip before starting to return records. Defaults to 0.
            num_taxa (int, optional): Number of top taxa to return. Defaults to 5.
        Returns:
            Response: A JSON response containing the taxon observation data and count.
                      If 'detail' is specified, it can be either 'minimal' or 'full'.
                      Returns an error message with a 400 status code for invalid parameters.
        Raises:
            ValueError: If 'limit' or 'offset' are not non-negative integers.
        """
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("minimal", "full"):
            return jsonify_error_message("When provided, 'detail' must be 'minimal' or 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
            num_taxa = int(request.args.get("num_taxa", 5))  # Default to 5 if not specified
        except ValueError:
            return jsonify_error_message("When provided, 'offset' 'numTaxa' and 'limit' must be non-negative integers."), 400
        
        data = (num_taxa, limit, offset, )
        
        with open(self.QUERIES_FOLDER + "/taxon_observation/get_top_taxa_count.sql", "r") as file:
            count_sql = file.read()
        countData = (num_taxa, )

        sql = ""
        if(accession_code is None):
            with open(self.QUERIES_FOLDER + "/taxon_observation/get_top_taxa_coverage.sql", "r") as file:
                sql = file.read()
        else: #TODO This either needs to be an observation accession code, or a taxa one.
            with open(self.QUERIES_FOLDER + "/taxon_observation/get_taxa_by_accession_code.sql", "r") as file:
                sql = file.read()
                data = (accession_code, )

        to_return = {}
        with psycopg.connect(**params, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()
                print("number of records")

                #if(accession_code is None):
                #    cur.execute(count_sql, countData)
                #    to_return["count"] = cur.fetchall()[0]["count"]
                #else:
                #    to_return["count"] = len(to_return["data"])
            conn.close()      
        return jsonify(to_return)

    def upload_strata_definitions(self, file):
        df = pd.read_parquet(file)
        with psycopg.connect(**self.params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
            return super().upload_to_table("stratum", 'sr', table_defs_config.stratum, df, True, conn)