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

def read_parquet_file(request, file_name='file', required=False):
    '''
    Check for a Parquet file in the provided API request, and if it
    exists, read in and return it as a Pandas dataframe.

    Parameters:
        request (flask.Request): The incoming Flask request object
        file_name (str): The name of the expected file
        required (bool): Is this a required file?
    Returns:
        pandas.DataFrame: The loaded data, or None if the file was not
            provided (and not required)
    Raises:
        UploadDataError: If the data file is missing (when required) or
            malformed
    '''
    if file_name not in request.files:
        if not required:
            return None
        else:
            raise UploadDataError(
                f"Missing required upload file {file_name}."
            )
    file = request.files[file_name]
    if file.filename == '':
        raise UploadDataError(
            "No selected file."
        )
    if not allowed_file(file.filename):
        raise UploadDataError(
            "File type not allowed. Only Parquet files are accepted."
        )
    try:
        df = pd.read_parquet(file)
    except Exception as e:
        raise UploadDataError(
            f"Failed to read {file_name}: {e}"
        )
    print(f"dataframe loaded with {len(df)} records.")
    return df

def merge_vb_codes(inserted_codes, df, mapping):
    '''
    Merge newly created VB codes into a dataframe based on the user code field.

    This function takes a dictionary of newly inserted codes, converts it to a
    dataframe, and merges it with an existing dataframe using a left join on the
    user code column. If the VB code column already exists in the target
    dataframe, the function combines the values, prioritizing existing values
    over new ones.

    Parameters:
        inserted_codes (dict): A dictionary containing the newly created codes,
            where keys are column names and values are lists of code values.
            Must contain columns that will be renamed according to the mapping.
        df (pandas.DataFrame): The target dataframe to merge the new codes into.
            Should contain a column matching the user code field specified in
            the mapping.
        mapping (dict): A dictionary mapping the column names from
            inserted_codes to the column names in the target dataframe. Should
            have exactly two key-value pairs: one for the user code column and
            one for the VB code column (e.g., {"user_py_code":
            "user_status_py_code", "vb_py_code": "vb_status_py_code"}).

    Returns:
        pandas.DataFrame: The modified dataframe with the new VB codes merged in.
            Existing VB code values are preserved when conflicts occur.
    '''
    codes_df = pd.DataFrame(inserted_codes).rename(columns=mapping)
    user_col, vb_col = list(mapping.values())
    df = df.merge(codes_df[[user_col, vb_col]], on=user_col, how='left')
    if f'{vb_col}_x' in df:
        df[vb_col] = df[f'{vb_col}_x'].combine_first(df[f'{vb_col}_y'])
        df.drop(columns=[f'{vb_col}_x', f'{vb_col}_y'], inplace=True)
    return df

def combine_json_return(main_dict, new_dict):
    '''
    Merge new_dict into main_dict by combining the nested dicts
    referenced by top level keys. For each top-level key, the nested
    dictionaries are merged, with values from new_dict taking precedence
    over values from main_dict when keys conflict.

    Parameters:
        main_dict (dict): The base dictionary containing nested dictionaries
            as values. Can be None, in which case new_dict is returned as-is.
        new_dict (dict): The dictionary to merge into main_dict. Its nested
            dictionaries will be combined with those in main_dict.

    Returns:
        dict: The merged dictionary where each top-level key maps to a
            dictionary that combines the nested dictionaries from both inputs.
            Values from new_dict override matching keys in main_dict.
    '''
    if main_dict is None:
        return new_dict
    result = {}
    for key in set(main_dict.keys()) | set(new_dict.keys()):
        result[key] = {**main_dict.get(key, {}),
                       **new_dict.get(key, {})}
    return result

def dry_run_check(conn, data, request):
    """
    Check if the request is a dry run and roll back the transaction if so.
    Parameters:
        conn: The database connection object.
        data: The data resulting from the upload request.
        request: The Flask request object containing query parameters.
    """
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

class UploadDataError(Exception):
    """Exception raised for missing or invalid upload data."""
    def __init__(self, message, status_code=400):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)

