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

class CoverMethodOperator(Operator):
    def __init__(self, params):
        super().__init__(params)

    def get_cover_method(self, accession_code, request):
        create_parquet = request.args.get("create_parquet", "false").lower() == "true"
        detail = request.args.get("detail", self.default_detail)
        if detail not in ("full"):
            return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
        try:
            limit = int(request.args.get("limit", self.default_limit))
            offset = int(request.args.get("offset", self.default_offset))
        except ValueError:
            return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
        
        with open(self.QUERIES_FOLDER + "/cover_method/get_cover_methods_count.sql", "r") as file:
            count_sql = file.read()

        if accession_code is not None:
            sql = open(self.QUERIES_FOLDER + "/cover_method/get_cover_method_by_accession_code.sql", "r").read()
            data = (accession_code, )
        else:
            data = (limit, offset, )
            with open(self.QUERIES_FOLDER + "/cover_method/get_cover_methods_full.sql", "r") as file:
                sql = file.read()
        
        to_return = {}
        with psycopg.connect(**self.params, cursor_factory=ClientCursor) as conn:
            if(create_parquet is False):
                conn.row_factory=dict_row
            else:
                print("about to make cover method parquet file")
                df_parquet = convert_to_parquet(sql, data, conn)
                print(df_parquet)
                conn.close()
                return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='cover_methods.parquet')
            with conn.cursor() as cur:
                cur.execute(sql, data)
                to_return["data"] = cur.fetchall()

                if accession_code is None:
                    cur.execute(count_sql)
                    to_return["count"] = cur.fetchall()[0]["count"]
                else:
                    to_return["count"] = len(to_return["data"])
            conn.close()   
        return jsonify(to_return)