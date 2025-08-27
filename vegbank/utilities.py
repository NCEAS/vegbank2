from flask import jsonify
import pandas as pd

ALLOWED_EXTENSIONS = 'parquet'

def convert_to_parquet(query, data, conn):
    dataframe = None
    with conn.cursor() as cur:
        SQLString = cur.mogrify(query, data)
        print(SQLString)
        dataframe = pd.read_sql(SQLString, conn)
    df_parquet = dataframe.to_parquet()
    return df_parquet

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def jsonify_error_message(message):
    return jsonify({
        "error":{
            "message": message
        }
    })