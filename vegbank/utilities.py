from flask import jsonify
import pandas as pd

ALLOWED_EXTENSIONS = 'parquet'

def convert_to_parquet(query, data, conn):
    '''
    Runs a provided SQL query with provided data against a provided database connection,
    then converts the resulting dataframe to a parquet file and returns it. 
    
    Parameters:
        query (str): The SQL query to be executed.
        data (tuple): The data to be used in the SQL query.
        conn (psycopg.Connection): The database connection object.
    Returns:
        bytes: The resulting dataframe converted to a parquet file in bytes format.
    '''
    dataframe = None
    with conn.cursor() as cur:
        SQLString = cur.mogrify(query, data)
        print(SQLString)
        dataframe = pd.read_sql(SQLString, conn)
    df_parquet = dataframe.to_parquet()
    return df_parquet

def allowed_file(filename):
    '''
    Checks if the provided filename has an allowed extension. 
    Allowed extension is defined in the ALLOWED_EXTENSIONS variable above.
    Parameters:
        filename (str): The name of the file to be checked.
    Returns:
        bool: True if the file has an allowed extension, False otherwise.
    '''
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def jsonify_error_message(message):
    '''
    Returns a JSON response with the provided error message.
    Parameters:
        message (str): The error message to be included in the JSON response.
    Returns:
        Response: A Flask JSON response containing the error message.
    '''
    return jsonify({
        "error":{
            "message": message
        }
    })


class QueryParameterError(Exception):
    """Exception raised for invalid query parameters."""
    def __init__(self, message, status_code=400):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)
