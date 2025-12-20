from flask import jsonify
import pandas as pd

ALLOWED_EXTENSIONS = 'parquet'

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

def validate_required_and_missing_fields(df, required_fields, table_defs, file_name):
    '''
    Validates that the provided dataframe contains all required fields and does not contain any unsupported fields.
    Parameters:
        df (pd.DataFrame): The dataframe to be validated.
        required_fields (list): A list of required field names.
        table_defs (list): A list of lists, where each inner list contains the field names for a specific table.
        file_name (str): The name of the file being validated (used in error messages).
    Returns:
        dict: A dictionary containing 'has_error' (bool) and 'error' (str) keys.
    '''
    df.columns = map(str.lower, df.columns)

    to_return = {
        'has_error': False,
        'error': ""
    }
    #Checking if the user's submission is missing any required columns
    error_string = ""
    missing_fields = []
    for field in required_fields:
        if field not in df.columns:
            missing_fields.append(field)
        elif df[field].isnull().any():
            missing_fields.append(field)
    if 0 < len(missing_fields):
            error_string += "The following required columns for " + file_name + " must be present with no null values : " + ", ".join(missing_fields) + ". "

    # Checking if the user submitted any unsupported columns
    extra_fields = set(df.columns)
    for insert_table_def in table_defs:
        extra_fields = extra_fields - set(insert_table_def)
    if 0 < len(extra_fields):
            error_string += "The following columns are not supported for " + file_name + ": " + ", ".join(extra_fields) + ". "

    if error_string != "":
        to_return['has_error'] = True
        to_return['error'] = error_string
    
    return to_return

def validate_file(file_name_input, request):
    if file_name_input not in request.files:
        return None
    file = request.files[file_name_input]
    if file.filename == '':
        return jsonify_error_message("No selected file."), 400
    if not allowed_file(file.filename):
        return jsonify_error_message(
            "File type not allowed. Only Parquet files are accepted."), 400
    return file

def dry_run_check(conn, data, request):
    if request.args.get('dry_run', 'false').lower() == 'true':  
        conn.rollback()
        return {
            "message": "dry run, transaction was rolled back",
            "dry run data" : data
        }
    else:
        return data

class QueryParameterError(Exception):
    """Exception raised for invalid query parameters."""
    def __init__(self, message, status_code=400):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)
