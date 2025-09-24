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


class Party(Operator):
    '''
    Defines operations related to party data management, 
    including retrieval and upload functionalities.
    Party: A person or organization associated with the collection or management of vegetation data.

    Inherits from the Operator parent class to utilize common default values.
    '''

    def __init__(self):
        super().__init__()
    

    def get_parties(self, request, params, accession_code):
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

        with open(self.QUERIES_FOLDER + "/party/get_parties_count.sql", "r") as file:
            count_sql = file.read()

        sql = ""
        if(accession_code is None): 
            with open(self.QUERIES_FOLDER + "/party/get_parties_full.sql", "r") as file:
                sql = file.read()
            data = (limit, offset, )
        else:
            with open(self.QUERIES_FOLDER + "/party/get_party_by_accession_code.sql", "r") as file:
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


    def upload_parties(request):
        return jsonify_error_message("POST method is not supported for parties."), 405
