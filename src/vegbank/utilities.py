from __future__ import annotations
import os
import re
import logging
from pathlib import Path
from importlib.resources import files
from itertools import islice
from flask import jsonify
import pandas as pd
from urllib.parse import quote_plus
from flask import jsonify

ALLOWED_EXTENSIONS = 'parquet'
logger = logging.getLogger(__name__)

def create_adbc_uri(params):
    """Create a PostgreSQL connection URI from connection parameters.

    Constructs a standard PostgreSQL connection URI string in the format
    postgresql://user:password@host:port/dbname from a dictionary of connection
    parameters. Validates that required parameters are present and provides
    sensible defaults for optional parameters.

    Args:
        params (dict): Dictionary containing connection parameters. Required keys:
            - 'user' (str): Database username
            - 'port' (str or int): Database port number
            - 'dbname' (str): Database name
            Optional keys:
            - 'password' (str): Database password. If not provided, URI will not
              include password component
            - 'host' (str): Database host. Defaults to 'localhost' if not provided

    Returns:
        str: A PostgreSQL connection URI in the format:
            - With password: "postgresql://user:password@host:port/dbname"
            - Without password: "postgresql://user@host:port/dbname"

    Raises:
        ValueError: If any required parameters ('user', 'port', 'dbname') are
            missing from the params dictionary. The error message lists all
            missing parameters.
    """
    required = ['user', 'port', 'dbname']
    missing = [k for k in required if not params.get(k)]
    if missing:
        raise ValueError(f"Missing required parameters: {', '.join(missing)}")

    user = quote_plus(params['user'])
    host = params.get('host') or 'localhost'
    port = params.get('port') or '5432'
    dbname = params['dbname']

    # Build URI with optional password
    password = params.get('password')
    if password:
        password_encoded = quote_plus(password)
        return f"postgresql://{user}:{password_encoded}@{host}:{port}/{dbname}"
    else:
        return f"postgresql://{user}@{host}:{port}/{dbname}"

def convert_psycopg_sql_to_adbc(sql):
    """Convert SQL query from psycopg2/psycopg3 format to ADBC parameter format.

    Transforms parameterized SQL queries from psycopg's %s placeholder style to
    ADBC's $1, $2, $3... positional parameter style. Handles escaped percent
    signs (%%) correctly by preserving them unchanged.

    Args:
        sql (str): SQL query string using psycopg-style placeholders. May
            contain:
            - %s for parameter placeholders
            - %% for literal percent signs (escaped)
            - Mix of both

    Returns:
        str: SQL query string with placeholders converted to ADBC format ($1,
            $2, etc.). Each %s is replaced with a sequential $n placeholder,
            while %% remains as %%.

    Note:
        The function uses a regex pattern that matches both %% and %s, ensuring
        escaped percent signs are preserved while only actual placeholders are
        converted.
    """
    counter = 1
    def replacer(match):
        nonlocal counter
        if match.group(0) == '%%':
            return '%%'  # Keep escaped percent signs
        result = f"${counter}"
        counter += 1
        return result
    return re.sub(r'%%|%s', replacer, sql)

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
    logger.info(f"{file_name} dataframe loaded with {len(df)} records.")
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
            If the user code column specified in the mapping is not present, df
            is returned unchanged.
        mapping (dict): A dictionary mapping the column names from
            inserted_codes to the column names in the target dataframe. Should
            have exactly two key-value pairs: one for the user code column and
            one for the VB code column (e.g., {"user_py_code":
            "user_status_py_code", "vb_py_code": "vb_status_py_code"}).

    Returns:
        pandas.DataFrame: The modified dataframe with the new VB codes merged
            in, or the original dataframe unchanged if the user code column is
            absent. Existing VB code values are preserved when conflicts occur.
    '''
    codes_df = pd.DataFrame(inserted_codes).rename(columns=mapping)
    user_col, vb_col = list(mapping.values())
    if user_col not in df.columns:
        logger.info(f"No '{user_col}' column found in df -- skipping merge.")
        return df
    df[user_col] = df[user_col].astype(str)
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
            "dry_run_data" : data
        }
    else:
        return data

def process_integer_param(param_name, param_value):
    err_msg = f"When provided, {param_name} must be a non-negative integer."
    try:
        param_value = int(param_value)
    except ValueError:
        raise QueryParameterError(err_msg)
    if param_value < 0:
        raise QueryParameterError(err_msg)
    return param_value

def process_option_param(param_name, param_value, options):
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

def load_sql(package: str, relative_path: str, encoding: str = "utf-8") -> str:
    """
    Load an SQL file either from a filesystem override directory (if set),
    or from packaged resources via importlib.resources.

    Args:
        package: Python package that contains SQL resources, e.g. "vegbank.queries"
        relative_path: Path inside queries, e.g. "cover_method/create_cover_method_temp_table.sql"
    """
    override_dir = os.getenv("QUERIES_DIR")
    if override_dir:
        p = Path(override_dir) / relative_path
        return p.read_text(encoding=encoding)

    parts = relative_path.split("/")
    return files(package).joinpath(*parts).read_text(encoding=encoding)

def batch_of_ids(list_of_ids, batch_size):
    """
    Yield successive batches from a list of IDs.

    Args:
        list_of_ids: An iterable of IDs to be batched.
        batch_size (int): The maximum number of IDs per batch.

    Returns:
        Generator yielding lists of IDs, each of length <= batch_size.
    """
    it = iter(list_of_ids)
    while batch := list(islice(it, batch_size)):
        yield batch

def update_obs_counts(conn, table, list_of_ids, batch_size=50000):
    """
    Update the d_obscount column for a set of records identified by ID.

    Executes SQL to update obs counts for each given ID in the context
    of a caller-specified table, processing records in batches if needed
    to avoid overloading the database with large IN-clauses.

    Args:
        conn: A database connection object with cursor support.
        table (str): Name of the table with d_obscount to be updated.
        list_of_ids (list): IDs of the table records to update.
        batch_size (int): Number of records to update per query. Defaults to 50000.

    Returns:
        None
    """
    if not list_of_ids:
        return

    # SQL statements to update counts for a batch of records, by table
    SQL = {
        'project': """
            UPDATE project pj
            SET d_obscount = COALESCE(obs.cnt, 0)
            FROM (
              SELECT project_id,
                     COUNT(observation_id) AS cnt
                FROM observation ob
                WHERE (emb_observation < 6 OR emb_observation IS NULL)
                  AND project_id = ANY(%s)
                GROUP BY project_id
              ) obs
            WHERE pj.project_id = obs.project_id
            """,
        'commconcept': """
            UPDATE commconcept cc
            SET d_obscount = COALESCE(obs.cnt, 0)
            FROM (
              SELECT ci.commconcept_id,
                     COUNT(DISTINCT cl.observation_id) AS cnt
                FROM commclass cl
                JOIN comminterpretation ci USING (commclass_id)
                WHERE (cl.emb_commclass < 6 OR cl.emb_commclass IS NULL)
                  AND ci.commconcept_id = ANY(%s)
                GROUP BY ci.commconcept_id
              ) obs
            WHERE cc.commconcept_id = obs.commconcept_id
            """,
        'plantconcept': """
            UPDATE plantconcept pc
            SET d_obscount = COALESCE(obs.cnt, 0)
            FROM (
              SELECT txi.plantconcept_id,
                     COUNT(DISTINCT txo.observation_id) AS cnt
                FROM taxonobservation txo
                JOIN taxoninterpretation txi USING (taxonobservation_id)
                WHERE (txo.emb_taxonobservation < 6 OR txo.emb_taxonobservation IS NULL)
                  AND txi.plantconcept_id = ANY(%s)
                GROUP BY txi.plantconcept_id
              ) obs
            WHERE pc.plantconcept_id = obs.plantconcept_id
            """,
        'party': """
            WITH party AS (
              SELECT party_id
                FROM party
                WHERE party_id = ANY(%s)
            ) UPDATE party py
            SET d_obscount = contrib.cnt
            FROM (
              SELECT party_id,
                     COUNT(DISTINCT observation_id) AS cnt
                FROM (
                  SELECT party_id, observation_id
                    FROM observation ob
                    JOIN observationcontributor obc USING (observation_id)
                    JOIN party USING (party_id)
                    WHERE (ob.emb_observation < 6 OR ob.emb_observation IS NULL)
                  UNION
                  SELECT party_id, observation_id
                    FROM observation ob
                    JOIN projectcontributor pjc USING (project_id)
                    JOIN party USING (party_id)
                    WHERE (ob.emb_observation < 6 OR ob.emb_observation IS NULL)
                  UNION
                  SELECT party_id, observation_id
                    FROM observation ob
                    JOIN commclass USING (observation_id)
                    JOIN classcontributor ccc USING (commclass_id)
                    JOIN party USING (party_id)
                    WHERE (ob.emb_observation < 6 OR ob.emb_observation IS NULL)
                ) GROUP BY party_id
              ) contrib
            WHERE py.party_id = contrib.party_id
            """,
    }

    if (sql := SQL.get(table)) is None:
        raise ValueError(f"Invalid table: '{table}'. Must be one of: {', '.join(SQL)}")

    sql_returning_counts = f"""
                WITH updated AS (
                {sql}
                RETURNING 1
            )
            SELECT COUNT(*) AS count FROM updated
        """
    count = 0
    with conn.cursor() as cur:
        for chunk in batch_of_ids(list_of_ids, batch_size):
            cur.execute(sql_returning_counts, (chunk,))
            count += cur.fetchone().get('count', 0)
    logger.info(f'Updating d_obscount for {count} {table} record(s)')

def update_last_obs_date(conn, table, list_of_ids, batch_size=50000):
    """
    Update the d_lastplotaddeddate column for a set of records identified by ID.

    Executes SQL to update date of last associated observation upload for each
    given project ID, processing records in batches if needed to avoid
    overloading the database with large IN-clauses.

    Args:
        conn: A database connection object with cursor support.
        table (str): Name of the table with d_obscount to be updated.
        list_of_ids (list): IDs of the table records to update.
        batch_size (int): Number of records to update per query. Defaults to 50000.

    Returns:
        None
    """
    if not list_of_ids:
        return

    # SQL statements to update d_lastplotaddeddate for a batch of records, by table
    SQL = {
        'project': """
            UPDATE project pj
            SET d_lastplotaddeddate = NOW()
            WHERE project_id = ANY(%s)
            """,
    }

    if (sql := SQL.get(table)) is None:
        raise ValueError(f"Invalid table: '{table}'. Must be one of: {', '.join(SQL)}")

    sql_returning_counts = f"""
                WITH updated AS (
                {sql}
                RETURNING 1
            )
            SELECT COUNT(*) AS count FROM updated
        """
    count = 0
    with conn.cursor() as cur:
        for chunk in batch_of_ids(list_of_ids, batch_size):
            cur.execute(sql_returning_counts, (chunk,))
            count += cur.fetchone().get('count', 0)
    logger.info(f'Updating d_lastplotaddeddate for {count} {table} record(s)')

def update_interpreted_observations(conn, table, list_of_ids, batch_size=50000):
    """
    Update denorm interp columns for a set of records identified by ID.

    Executes SQL to update denormalized original and current interpretation
    fields in the taxon observation table for each given taxon interpretation
    ID, processing records in batches if needed to avoid overloading the
    database with large IN-clauses.

    Args:
        conn: A database connection object with cursor support.
        table (str): Name of the table with d_obscount to be updated.
        list_of_ids (list): IDs of the table records to update.
        batch_size (int): Number of records to update per query. Defaults to 50000.

    Returns:
        None
    """
    if not list_of_ids:
        return

    # SQL statements to update counts for a batch of records, by table
    sql = """
        WITH interp_data AS (
            SELECT
                ti.taxonobservation_id,
                ti.plantconcept_id,
                ti.originalinterpretation,
                ti.currentinterpretation,
                scif.plantname AS scif,
                scin.plantname AS scin,
                comm.plantname AS comm,
                code.plantname AS code
            FROM taxoninterpretation ti
            JOIN plantconcept pc USING (plantconcept_id)
            LEFT JOIN plantusage u_scif ON pc.plantconcept_id = u_scif.plantconcept_id
                                        AND LOWER(u_scif.classsystem) = 'scientific'
            LEFT JOIN plantname scif ON u_scif.plantname_id = scif.plantname_id
            LEFT JOIN plantusage u_scin ON pc.plantconcept_id = u_scin.plantconcept_id
                                        AND LOWER(u_scin.classsystem) = 'scientific without authors'
            LEFT JOIN plantname scin ON u_scin.plantname_id = scin.plantname_id
            LEFT JOIN plantusage u_comm ON pc.plantconcept_id = u_comm.plantconcept_id
                                        AND LOWER(u_comm.classsystem) = 'english common'
            LEFT JOIN plantname comm ON u_comm.plantname_id = comm.plantname_id
            LEFT JOIN plantusage u_code ON pc.plantconcept_id = u_code.plantconcept_id
                                        AND LOWER(u_code.classsystem) = 'code'
            LEFT JOIN plantname code ON u_code.plantname_id = code.plantname_id
            WHERE ti.taxoninterpretation_id = ANY(%s)
              AND (ti.originalinterpretation = true OR ti.currentinterpretation = true)
        ),
        orig AS (
            SELECT DISTINCT ON (taxonobservation_id)
                taxonobservation_id, plantconcept_id, scif, scin, comm, code
            FROM interp_data
            WHERE originalinterpretation = true
            ORDER BY taxonobservation_id, plantconcept_id ASC
        ),
        curr AS (
            SELECT DISTINCT ON (taxonobservation_id)
                taxonobservation_id, plantconcept_id, scif, scin, comm, code
            FROM interp_data
            WHERE currentinterpretation = true
            ORDER BY taxonobservation_id, plantconcept_id DESC
        )
        UPDATE taxonobservation tobs
        SET int_origplantconcept_id = orig.plantconcept_id,
            int_origplantscifull = orig.scif,
            int_origplantscinamenoauth = orig.scin,
            int_origplantcommon = orig.comm,
            int_origplantcode = orig.code,
            int_currplantconcept_id = curr.plantconcept_id,
            int_currplantscifull = curr.scif,
            int_currplantscinamenoauth = curr.scin,
            int_currplantcommon = curr.comm,
            int_currplantcode = curr.code
        FROM orig
        FULL JOIN curr ON orig.taxonobservation_id = curr.taxonobservation_id
        WHERE tobs.taxonobservation_id = COALESCE(orig.taxonobservation_id, curr.taxonobservation_id)
        """

    sql_returning_counts = f"""
                WITH updated AS (
                {sql}
                RETURNING 1
            )
            SELECT COUNT(*) AS count FROM updated
        """
    count = 0
    with conn.cursor() as cur:
        for chunk in batch_of_ids(list_of_ids, batch_size):
            cur.execute(sql_returning_counts, (chunk, ))
            count += cur.fetchone().get('count', 0)
    logger.info(f'Updating orig and curr interpretations for {count} {table} record(s)')

def update_search_vector(conn, table, list_of_ids, batch_size=50000):
    """
    Update the search_vector column for a set of records identified by ID.

    Executes the database function build_<table>_search_vector() for
    each given ID, processing records in batches to avoid overloading the
    database with large IN-clauses.

    Args:
        conn: A database connection object with cursor support.
        table (str): Name of the table with search_vector to be updated.
        list_of_ids (list): IDs of the table records to update.
        batch_size (int): Number of records to update per query. Defaults to 50000.

    Returns:
        None
    """
    if not list_of_ids:
        return
    with conn.cursor() as cur:
        for chunk in batch_of_ids(list_of_ids, batch_size):
            cur.execute(
                f"""
                UPDATE {table}
                  SET search_vector = build_{table}_search_vector({table}_id)
                  WHERE {table}_id = ANY(%s)
                """,
                (chunk,))

def validate_dataset_json(json):
    """
    Validate the structure of the dataset JSON object.
    Parameters:
        data: The JSON object to validate.
    Raises:
        QueryParameterError: If the JSON structure is invalid.
    """
    if not isinstance(json, dict):
        raise QueryParameterError("Invalid JSON structure: expected a JSON object.")
    if 'name' not in json:
        raise QueryParameterError("Missing 'name' key in JSON: expected a 'name' key containing the name of the dataset.")
    if not isinstance(json['name'], str) or json['name'].strip() == "":
        raise QueryParameterError("Invalid 'name' value: 'name' must be a non-empty string.")
    if 'description' not in json:
        raise QueryParameterError("Missing 'description' key in JSON: expected a 'description' key containing a description of the dataset.")
    if not isinstance(json['description'], str) or json['description'].strip() == "":
        raise QueryParameterError("Invalid 'description' value: 'description' must be a non-empty string.")
    if 'type' not in json:
        raise QueryParameterError("Missing 'type' key in JSON: expected a 'type' key containing the type of the dataset.")
    if not isinstance(json['type'], str) or json['type'].strip() == "":
        raise QueryParameterError("Invalid 'type' value: 'type' must be a non-empty string.")
    if 'data' not in json: 
        raise QueryParameterError("Missing 'data' key in JSON: expected a 'data' key containing the dataset information.")
    data = json['data']
    if not isinstance(data, dict):
        raise QueryParameterError("Invalid JSON structure: 'data' should be a dictionary with the element 'observation' containing a list of observation codes.")
    if 'observation' not in data:
        raise QueryParameterError("Missing 'observation' key in JSON: 'data' should contain an 'observation' key with a list of observation codes.")
    if not isinstance(data['observation'], list):  
        raise QueryParameterError("Invalid 'observation' structure: 'observation' should be a list of observation codes.")
    extra_keys = set(data.keys()) - {'observation'}
    if extra_keys:
        raise QueryParameterError(f"Invalid keys in JSON: {', '.join(extra_keys)}. Only 'observation' key is allowed.")
    if len(data['observation']) == 0:
        raise QueryParameterError("Invalid 'observation' value: 'observation' list cannot be empty.")
    for observation in data['observation']:
        if not isinstance(observation, str) or not observation.startswith('ob.') or not observation[3:].isdigit():
            raise QueryParameterError(f"Invalid observation code: '{observation}'. It must follow the pattern 'ob.' followed by an integer.")

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

