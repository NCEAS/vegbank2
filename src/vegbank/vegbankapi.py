from flask import Flask, jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import io
import time
import traceback
import os
import logging
from vegbank.utilities import jsonify_error_message, dry_run_check, read_parquet_file, validate_dataset_json
from vegbank.auth import (
    auth_bp, 
    init_oauth, 
    require_scope, 
    SCOPE_ADMIN, 
    SCOPE_CONTRIBUTOR, 
    SCOPE_USER,
    get_access_mode,
    ACCESS_MODE_READ_ONLY
)
from vegbank.repositories import (
    IdentifiersQueries,
    Overview,
)
from vegbank.operators import (
    TaxonImportance,
    TaxonInterpretation,
    TaxonObservation,
    PlotObservation,
    PlotObservationBundle,
    Party,
    PlantConcept,
    CommunityClassification,
    CommunityInterpretation,
    CommunityConcept,
    CoverMethod,
    NamedPlace,
    Project,
    Role,
    StemCount,
    Stratum,
    StratumMethod,
    Reference,
    UserDataset,
)


UPLOAD_FOLDER = '/vegbank2/uploads' #For future use with uploading parquet files if necessary

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY', os.urandom(32).hex())

# Initialize logging
logger = logging.getLogger(__name__)

init_oauth(app)
app.register_blueprint(auth_bp)

params = {}
params['dbname'] = os.getenv('VB_DB_NAME')
params['user'] = os.getenv('VB_DB_USER')
params['host'] = os.getenv('VB_DB_HOST')
params['port'] = os.getenv('VB_DB_PORT')
params['password'] = os.getenv('VB_DB_PASS')

default_detail = "full"
default_limit = 1000
default_offset = 0

@app.before_request
def before_request():
    """
    Log the incoming request method and path, and check if uploads are allowed for POST requests.
    
    Upload behavior is determined by accessMode:
    - 'read_only': No uploads allowed
    - 'open': Uploads allowed
    - 'authenticated': Uploads allowed (with scope restrictions on individual endpoints)
    """
    logger.debug(f"Received {request.method} request for {request.path}")
    
    if request.method == 'POST':
        mode = get_access_mode()
        
        if mode == ACCESS_MODE_READ_ONLY:
            return jsonify_error_message("Uploads not allowed in read_only deployment mode."), 403

@app.route("/")
def welcome_page():
    return "<h1>Welcome to the VegBank API</h1>"


@app.route("/plot-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<vb_code>", methods=['GET'])
@app.route("/projects/<vb_code>/plot-observations", methods=['GET'])
@app.route("/parties/<vb_code>/plot-observations", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/plot-observations", methods=['GET'])
@app.route("/named-places/<vb_code>/plot-observations", methods=['GET'])
@app.route("/community-concepts/<vb_code>/plot-observations", methods=['GET'])
@app.route("/cover-methods/<vb_code>/plot-observations", methods=['GET'])
@app.route("/stratum-methods/<vb_code>/plot-observations", methods=['GET'])
@app.route("/user-datasets/<vb_code>/plot-observations", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def plot_observations(vb_code, claims=None):
    """
    Retrieve either an individual plot observation or a collection, or
    upload a new set of plot observations.

    This function handles HTTP requests for plot observations, currently
    supporting POST and GET methods. For any other HTTP method, it returns a 405
    error.

    POST: Upload a series of files from the loader schema and return the new codes 
    and counts of new records based on the types of new records created. 

    POST Parameters:
        plot_observations (FileStorage, optional): Parquet file containing plot
            observation data.
        projects (FileStorage, optional): Parquet file containing project data.
        parties (FileStorage, optional): Parquet file containing party data.
        references (FileStorage, optional): Parquet file containing reference data.
        strata (FileStorage, optional): Parquet file containing strata
            definition data.
        strata_cover_data (FileStorage, optional): Parquet file containing taxon 
            observations and taxon importances.
        taxon_interpretations (FileStorage, optional): Parquet file containing taxon 
            interpretation data.
    
    All post parameters are optional except plot_observations.

    GET: If a valid plot observation code is provided (e.g., ob.1), returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of plot observation
    records associated with that resource. If no vb_code is provided, returns
    the full collection of plot observation records. Collection responses may be
    further mediated by pagination parameters and other filtering query
    parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the plot observation
            being retrieved, or for a resource of a different type used to focus
            plot observation retrieval. If None, retrieves all plot observations.
        claims (dict, optional): User claims extracted from JWT token during
            authentication. Contains user info (preferred_username, email, scopes).
            Only populated when VB_ACCESS_MODE=authenticated. Used for audit
            logging and validation. Injected by @require_scope decorator.

    GET Query Parameters:
        search (str, optional): Plot observation search query.
        detail (str, optional): Level of detail for the response.
            Can be either 'minimal' or 'full'. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        num_taxa (int, optional): Number of taxa to return per plot observation,
            in descending order of max cover if detail=minimal, and in
            alphabetical order by plant name if detail=full. Defaults to 5.
        num_comms (int, optional): Number of communities to return per
            plot observation, ordered by commclass_id. Defaults to 5.
        sort (str, optional): Sort order for returned records. Can be
            'default' (sort by ID) or 'author_obs_code', and both values
            can be prepended with a '-' to sort in descending order
            (e.g., '-author_obs_code'). Defaults to 'default'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.
        bundle (str, optional): Return plot observations and numerous related
            resources in a multi-file bundle. Currently accepts only 'csv', in
            which case a zip archive of CSV files will be returned. Defaults to
            None.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved plot observation(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    plot_observation_operator = PlotObservation(params)
    if request.method == 'POST':
        return PlotObservation(params).upload_all(request)
    elif request.method == 'GET':
        if request.args.get('bundle') is not None:
            return PlotObservationBundle(params).get_vegbank_resources(request, vb_code)
        else:
            return plot_observation_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/taxon-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/taxon-observations", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/taxon-observations", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def taxon_observations(vb_code, claims=None):
    """
    Retrieve an individual taxon observation or a collection, or upload a new
    set of taxon observations.

    This function handles HTTP requests for taxon observations, currently
    supporting POST and GET methods. For any other HTTP method, it returns a 405
    error.

    POST: Facilitates uploading of new taxon observations as an attached Parquet
    file, if permitted via an environment variable.

    GET: If a valid taxon observation code is provided, returns the corresponding
    record if it exists. If a valid code for a different supported resource type
    is provided, returns the collection of taxon observation records associated with
    that resource. If no vb_code is provided, returns the full collection of
    taxon observation records. Collection responses may be further mediated by
    pagination parameters and other filtering query parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the taxon
            observation being retrieved, or for a resource of a
            different type used to focus taxon observation retrieval. If
            None, retrieves all taxon observations.
        claims (dict, optional): User claims extracted from JWT token during
            authentication. Contains user info (preferred_username, email, scopes).
            Only populated when VB_ACCESS_MODE=authenticated. Used for audit
            logging and validation. Injected by @require_scope decorator.

    GET Query Parameters:
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
            - 200: Successfully retrieved taxon observation(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    taxon_observation_operator = TaxonObservation(params)
    if request.method == 'POST':
        to_return = None
        file = request.files['file']
        try:
            with connect(**params, row_factory=dict_row) as conn:
                    df = pd.read_parquet(file)
                    to_return = taxon_observation_operator.upload_strata_definitions(df, conn)
                    to_return = dry_run_check(conn, to_return, request)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500
        return to_return
    elif request.method == 'GET':
        return taxon_observation_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/taxon-importances", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-importances/<vb_code>", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/taxon-importances", methods=['GET'])
@app.route("/plot-observations/<vb_code>/taxon-importances", methods=['GET'])
@app.route("/taxon-observations/<vb_code>/taxon-importances", methods=['GET'])
def taxon_importances(vb_code):
    """
    Retrieve an individual taxon importance or a collection.

    This function handles HTTP requests for taxon importance data. It currently
    supports only the GET method to retrieve records. If a POST request is made,
    it returns an error message indicating that POST is not supported. For any
    other HTTP method, it returns a 405 error.

    GET: If a valid taxon importance code is provided, returns the corresponding
    record if it exists. If a valid code for a different supported resource type
    is provided, returns the collection of taxon importance records associated with
    that resource. If no vb_code is provided, returns the full collection of
    taxon importance records. Collection responses may be further mediated by
    pagination parameters and other filtering query parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the taxon importance
            being retrieved, or for a resource of a different type used to focus
            taxon importance retrieval. If None, retrieves all taxon importances.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved taxon importance(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    taxon_importance_operator = TaxonImportance(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for taxon-importances."), 405
    elif request.method == 'GET':
        return taxon_importance_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/stem-counts", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/stem-counts/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/stem-counts", methods=['GET'])
@app.route("/taxon-observations/<vb_code>/stem-counts", methods=['GET'])
@app.route("/taxon-importances/<vb_code>/stem-counts", methods=['GET'])
def stem_counts(vb_code):
    """
    Retrieve either an individual stem count or a collection of counts.

    This function handles HTTP requests for stem counts. It currently supports
    only the GET method to retrieve records. If a POST request is made, it
    returns an error message indicating that POST is not supported. For any
    other HTTP method, it returns a 405 error.

    GET: If a valid stem count code is provided (e.g., `sc.1`), returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of stem count records
    associated with that resource. If no vb_code is provided, returns the full
    collection of stem count records. Collection responses may be further
    mediated by pagination parameters and other filtering query parameters.

    Parameters (for GET requests only):
        vb_code (str or None): The unique identifier for the stem count
            being retrieved. If None, retrieves all stem counts.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Only 'false' is defined for this method. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved stem count(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    stem_count_operator = StemCount(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for stem-counts."), 405
    elif request.method == 'GET':
        return stem_count_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/strata-cover-data", methods=['POST'])
def strata_cover_data():
    """
    Upload strata cover data from a Parquet file.

    This function handles HTTP POST requests to upload strata cover data.
    It expects a Parquet file containing strata cover data in the request.
    Uploads data to the taxon observation and taxon importance tables.
    If the upload is successful, it returns a JSON response indicating
    success. If there are any errors during the upload process, it returns
    an appropriate error message.

    POST Parameters: 
        file (FileStorage): The uploaded Parquet file containing strata
            cover data.

    Returns:
        flask.Response: A JSON response indicating success or failure of
            the upload operation.
    """
    taxon_observation_operator = TaxonObservation(params)
    to_return = None
    try:
        scd_df = read_parquet_file(request, 'file', required=True)
        with connect(**params, row_factory=dict_row) as conn:
            to_return = taxon_observation_operator.upload_strata_cover_data(scd_df, conn)
            to_return = dry_run_check(conn, to_return, request)
        conn.close()
    except Exception as e:
        print(traceback.format_exc())
        return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500    
    return to_return

@app.route("/stem-data", methods=['POST'])
def stem_data():
    """
    Upload stem location data from a Parquet file.

    This function handles HTTP POST requests to upload stem data.
    It expects a Parquet file containing stem data in the request.
    Uploads data to the stem location and stem count tables..
    If the upload is successful, it returns a JSON response indicating
    success. If there are any errors during the upload process, it returns
    an appropriate error message.

    Query Parameters:
        dry_run (str, optional): If set to 'true', the upload will be
            simulated without committing changes to the database.
            Defaults to 'false'.

    POST Parameters: 
        file (FileStorage): The uploaded Parquet file containing stem data.

    Returns:
        flask.Response: A JSON response indicating success or failure of
            the upload operation.
    """
    taxon_observation_operator = TaxonObservation(params)
    to_return = None
    
    try:
        sd_df = read_parquet_file(request, 'file', required=True)
        with connect(**params, row_factory=dict_row) as conn:
            to_return = taxon_observation_operator.upload_stem_data(sd_df, conn)
            to_return = dry_run_check(conn, to_return, request)
        conn.close()
    except Exception as e:
        print(traceback.format_exc())
        return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500    
    return to_return

@app.route("/taxon-interpretations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-interpretations/<vb_code>", methods=['GET'])
@app.route("/taxon-observations/<vb_code>/taxon-interpretations", methods=['GET'])
@app.route("/plot-observations/<vb_code>/taxon-interpretations", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/taxon-interpretations", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def taxon_interpretations(vb_code, claims=None):
    """
    Retrieve either an individual taxon interpretation or a collection, or
    upload a new set of taxon interpretations.

    This function handles HTTP requests for taxon interpretations, currently
    supporting POST and GET methods. For any other HTTP method, it returns a 405
    error.

    POST: Facilitates uploading of new taxon interpretations as an attached
    Parquet file, if permitted via an environment variable. If the upload is
    successful, it returns a JSON response indicating success. If there are any
    errors during the upload process, it returns an appropriate error message.

    GET: If a valid taxon interpretation code is provided (e.g., ti.1), returns
    the corresponding record if it exists. If a valid code for a different
    supported resource type is provided, returns the collection of taxon
    interpretation records associated with that resource. If no vb_code is
    provided, returns the full collection of taxon interpretation records.
    Collection responses may be further mediated by pagination parameters and
    other filtering query parameters.

    Parameters (for GET requests only):
        vb_code (str or None): The unique identifier for the plot observation
            being retrieved, or for a resource of a different type used to focus
            plot observation retrieval. If None, retrieves all plot observations.

    POST Query Parameters:
        dry_run (str, optional): If set to 'true', the upload will be
            simulated without committing changes to the database.
            Defaults to 'false'.

    POST Payload:
        file (FileStorage): The uploaded Parquet file containing taxon
            interpretations.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Can be either 'minimal' or 'full'. Defaults to 'full'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved taxon interpretation(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
            - 500: Invalid data upload
    """
    taxon_interpretation_operator = TaxonInterpretation(params)
    if request.method == 'POST':
        taxon_observation_operator = TaxonObservation(params)
        to_return = None
        
        try:
            ti_df = read_parquet_file(request, 'file', required=True)
            with connect(**params, row_factory=dict_row) as conn:
                to_return = taxon_observation_operator.upload_taxon_interpretations(ti_df, conn)
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(
                f"An error occurred during upload: {str(e)}"), 500
        return jsonify(to_return)
    elif request.method == 'GET':
        return taxon_interpretation_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-classifications", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/community-classifications/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/community-classifications", methods=['GET'])
@app.route("/community-concepts/<vb_code>/community-classifications", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def community_classifications(vb_code, claims=None):
    """
    Retrieve either an individual community classification or a collection.

    This function handles HTTP requests for community classifications. It
    currently supports only the GET method to retrieve community
    classifications. If a POST request is made, it returns an error message
    indicating that POST is not supported. For any other HTTP method, it returns
    a 405 error.

    GET: If a valid community classification code is provided, returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of community
    classification records associated with that resource. If no vb_code is
    provided, returns the full collection of community classification records.
    Collection responses may be further mediated by pagination parameters and
    other filtering query parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the community
            classification being retrieved, or for a resource of a different
            type used to focus community classification retrieval. If None,
            retrieves all community classifications.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Can be either 'minimal' or 'full'. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved community classification(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    community_classification_operator = CommunityClassification(params)
    if request.method == 'POST':
        return community_classification_operator.upload_all(request)
    elif request.method == 'GET':
        return community_classification_operator.get_vegbank_resources(request,
                                                                       vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-interpretations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/community-interpretations/<vb_code>", methods=['GET'])
@app.route("/community-classifications/<vb_code>/community-interpretations", methods=['GET'])
@app.route("/plot-observations/<vb_code>/community-interpretations", methods=['GET'])
@app.route("/community-concepts/<vb_code>/community-interpretations", methods=['GET'])
def community_interpretations(vb_code):
    """
    Retrieve either an individual community interpretation or a collection.

    This function handles HTTP requests for community interpretations.
    It currently supports only the GET method to retrieve community
    interpretations. If a POST request is made, it returns an error message
    indicating that POST is not supported. For any other HTTP method, it
    returns a 405 error.

    GET: If a valid community interpretation code is provided, returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of community interpretation
    records associated with that resource. If no vb_code is provided, returns
    the full collection of community interpretation records. Collection
    responses may be further mediated by pagination parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the community
            interpretation being retrieved, or for a resource of a different
            type used to focus community interpretation retrieval. If None,
            retrieves all community interpretations.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Can be either 'minimal' or 'full'. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved community interpretation(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    community_interpretation_operator = CommunityInterpretation(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for community-interpretations."), 405
    elif request.method == 'GET':
        return community_interpretation_operator.get_vegbank_resources(request,
                                                                       vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-concepts", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<vb_code>")
@app.route("/community-classifications/<vb_code>/community-concepts", methods=['GET'])
@app.route("/parties/<vb_code>/community-concepts", methods=['GET'])
@app.route("/plot-observations/<vb_code>/community-concepts", methods=['GET'])
@app.route("/references/<vb_code>/community-concepts", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def community_concepts(vb_code, claims=None):
    """
    Retrieve either an individual community concept or a collection.

    This function handles HTTP requests for community concepts. It currently
    supports only the GET method to retrieve community concepts. If a POST
    request is made, it returns an error message indicating that POST is not
    supported. For any other HTTP method, it returns a 405 error.

    GET: If a valid community concept code is provided, returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of community concept
    records associated with that resource. If no vb_code is provided, returns
    the full collection of community concept records. Collection responses may
    be further mediated by pagination parameters and other filtering query
    parameters.

    POST: Upload a set of files conforming with the comm concept loader schema,
    and return counts and created codes of newly inserted records. Includes an
    option for deactivating existing concepts superseded by the newly uploaded
    data.

    Parameters:
        vb_code (str or None): The unique identifier for the community concept
            being retrieved, or for a resource of a different type used to focus
            community concept retrieval. If None, retrieves all community
            concepts.
        claims (dict, optional): User claims extracted from JWT token during
            authentication. Contains user info (preferred_username, email, scopes).
            Only populated when VB_ACCESS_MODE=authenticated. Used for audit
            logging and validation. Injected by @require_scope decorator.

    POST Parameters:
        community_concepts (FileStorage): Parquet file containing new community
            concepts and corresponding status details.
        community_names (FileStorage, optional): Parquet file containing zero or
            more community name usages (and related details) for each concept.
        community_correlations (FileStorage, optional): Parquet file containing
            correlations between concepts.
        parties (FileStorage, optional): Parquet file containing one or more new
            parties (people or organizations) providing perspectives on the
            uploaded concepts.
        references (FileStorage, optional): Parquet file containing one or more
            new references associated with the uploaded community concepts.
        deactivation (str, optional): Which existing community concepts in VegBank
            should be deactivated when inserting the new concepts. Can be "none"
            (don't deactivate any records) or "by_party" (deactivate all existing
            community status and related usage records associated with any
            parties that are also associated with the uploaded concepts).
            Defaults to "none".

    GET Query Parameters:
        search (str, optional): Community name search query.
        status (str, optional): Status criterion for returned community concepts.
            Can be 'any', 'current', 'accepted', or 'current_accepted'. Defaults
            to 'any'.
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        sort (str, optional): Sort order for returned records. Can be
            'default' (sort by ID), 'comm_name', or 'obs_count', all of
            which can be prepended with a '-' to sort in descending
            order (e.g., '-obs_count'). Defaults to 'default'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved community concept(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    community_concept_operator = CommunityConcept(params)
    if request.method == 'POST':
        return community_concept_operator.upload_all(request)
    elif request.method == 'GET':
        return community_concept_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/plant-concepts", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/plant-concepts/<vb_code>")
@app.route("/parties/<vb_code>/plant-concepts", methods=['GET'])
@app.route("/references/<vb_code>/plant-concepts", methods=['GET'])
@app.route("/taxon-observations/<vb_code>/plant-concepts", methods=['GET'])
@app.route("/plot-observations/<vb_code>/plant-concepts", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def plant_concepts(vb_code, claims=None):
    """
    Retrieve either an individual plant concept or a collection.

    This function handles HTTP requests for plant concepts. It currently
    supports only the GET method to retrieve plant concepts. If a POST request
    is made, it returns an error message indicating that POST is not supported.
    For any other HTTP method, it returns a 405 error.

    GET: If a valid plant concept code is provided, returns the corresponding
    record if it exists. If a valid code for a different supported resource type
    is provided, returns the collection of plant concept records associated with
    that resource. If no vb_code is provided, returns the full collection of
    plant concept records. Collection responses may be further mediated by
    pagination parameters and other filtering query parameters.

    POST: Upload a set of files conforming with the plant concept loader schema,
    and return counts and created codes of newly inserted records. Includes an
    option for deactivating existing concepts superseded by the newly uploaded
    data.

    Parameters:
        vb_code (str or None): The unique identifier for the plant
            concept being retrieved, or for a resource of a different type used
            to focus plant concept retrieval. If None, retrieves all plant
            concepts.

    GET Query Parameters:
        search (str, optional): Plant name search query.
        status (str, optional): Status criterion for returned plant concepts.
            Can be 'any', 'current', 'accepted', or 'current_accepted'. Defaults
            to 'any'.
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        sort (str, optional): Sort order for returned records. Can be
            'default' (sort by ID), 'plant_name', or 'obs_count', all of
            which can be prepended with a '-' to sort in descending
            order (e.g., '-obs_count'). Defaults to 'default'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    POST Parameters:
        plant_concepts (FileStorage): Parquet file containing new plant concepts
            and corresponding status details.
        plant_names (FileStorage, optional): Parquet file containing zero or
            more plant name usages (and related details) for each concept.
        plant_correlations (FileStorage, optional): Parquet file containing
            correlations between concepts.
        parties (FileStorage, optional): Parquet file containing one or more new
            parties (people or organizations) providing perspectives on the
            uploaded concepts.
        references (FileStorage, optional): Parquet file containing one or more
            new references associated with the uploaded plant concepts.
        deactivation (str, optional): Which existing plant concepts in VegBank
            should be deactivated when inserting the new concepts. Can be "none"
            (don't deactivate any records), "by_party" (deactivate all existing
            plant status and related usage records associated with any parties
            that are also associated with the uploaded concepts), or
            "by_party_below_order" (like "by_party", but only apply to concepts
            at the family taxonomic level or lower, or with unspecified level).
            Defaults to "none".

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved plant concept(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    plant_concept_operator = PlantConcept(params)
    if request.method == 'POST':
        return plant_concept_operator.upload_all(request)
    elif request.method == 'GET':
        return plant_concept_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/parties", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/parties", methods=['GET'])
@app.route("/community-classifications/<vb_code>/parties", methods=['GET'])
@app.route("/projects/<vb_code>/parties", methods=['GET'])
@require_scope(SCOPE_ADMIN, methods=['POST'])
def parties(vb_code, claims=None):
    """
    Retrieve either an individual party or a collection.

    This function handles HTTP requests for parties. It currently supports only
    the GET method to retrieve parties. If a POST request is made, it returns an
    error message indicating that POST is not supported. For any other HTTP
    method, it returns a 405 error.

    GET: If a valid party code is provided, returns the corresponding record
    if it exists. If a valid code for a different supported resource type is
    provided, returns the collection of party records associated with that
    resource. If no vb_code is provided, returns the full collection of party
    records. Collection responses may be further mediated by pagination
    parameters and other filtering query parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the party being
            retrieved, or for a resource of a different type used to focus
            party retrieval. If None, retrieves all parties.

    GET Query Parameters:
        search (str, optional): Party name/organization search query.
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        sort (str, optional): Sort order for returned records. Can be
            'default' (sort by ID), 'surname', 'organization_name', or
            'obs_count', all of which can be prepended with a '-' to
            sort in descending order (e.g., '-obs_count'). Defaults to
            'default'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved party record(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    party_operator = Party(params)
    if request.method == 'POST':
        file = request.files['file']
        to_return = None
        try:
            with connect(**params, row_factory=dict_row) as conn:
                py_df = pd.read_parquet(file)
                to_return = party_operator.upload_parties(py_df, conn)
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500    
        return jsonify(to_return)
    elif request.method == 'GET':
        return party_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/projects", defaults={'pj_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<pj_code>", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def projects(pj_code, claims=None):
    """
    Retrieve either an individual project or a collection, or upload a new set
    of projects.

    This function handles HTTP requests for projects. For GET requests, it
    retrieves project details associated with a specified project code (e.g.,
    `pj.1`) or a paginated collection of all projects if no code is provided;
    see below for query parameters to support pagination and detail. For POST
    requests, it facilitates uploading of new projects if permitted via an
    environment variable. For any other HTTP method, it returns a 405 error.

    Parameters:
        pj_code (str or None): The unique identifier for the project being
            retrieved. If None, retrieves all projects.
        claims (dict, optional): User claims extracted from JWT token during
            authentication. Contains user info (preferred_username, email, scopes).
            Only populated when VB_ACCESS_MODE=authenticated. Used for audit
            logging and validation. Injected by @require_scope decorator.

    GET Query Parameters:
        search (str, optional): Project name search query.
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        sort (str, optional): Sort order for returned records. Can be
            'default' (sort by ID), 'project_name', or 'obs_count', all of
            which can be prepended with a '-' to sort in descending
            order (e.g., '-obs_count'). Defaults to 'default'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved project(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    project_operator = Project(params)
    if request.method == 'POST':
        try:
            pj_df = read_parquet_file(request, 'file', required=True)
            with connect(**params, row_factory=dict_row) as conn:
                to_return = project_operator.upload_project(pj_df, conn)
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500
        return jsonify(to_return)
    elif request.method == 'GET':
        return project_operator.get_vegbank_resources(request, pj_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/cover-methods", defaults={'cm_code': None}, methods=['GET', 'POST'])
@app.route("/cover-methods/<cm_code>")
@require_scope(SCOPE_ADMIN, methods=['POST'])
def cover_methods(cm_code, claims=None):
    """
    Retrieve either an individual cover method or a collection, or upload a new
    cover method.

    This function handles HTTP requests for cover methods. For GET requests, it
    retrieves cover method details associated with a specified cover method code
    (e.g., `cm.1`) or a paginated collection of all cover methods if no code is
    provided; see below for query parameters to support pagination and detail.
    For POST requests, it facilitates uploading of cover methods and associated references if user is permitted. 
    For any other HTTP method, it returns a 405
    error.

    Parameters (for GET requests only):
        cm_code (str or None): The unique identifier for the cover method
            being retrieved. If None, retrieves all cover methods.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved cover method(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    cover_method_operator = CoverMethod(params)
    if request.method == 'POST':
        return cover_method_operator.upload_all(request)
    elif request.method == 'GET':
        return cover_method_operator.get_vegbank_resources(request, cm_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/stratum-methods", defaults={'sm_code': None}, methods=['GET', 'POST'])
@app.route("/stratum-methods/<sm_code>", methods=['GET'])
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def stratum_methods(sm_code, claims=None):
    """
    Retrieve either an individual stratum method or a collection, or upload a
    new stratum method.

    This function handles HTTP requests for stratum methods. For GET requests,
    it retrieves stratum method details associated with a specified stratum
    method code (e.g., `sm.1`) or a paginated collection of all stratum methods
    if no code is provided; see below for query parameters to support pagination
    and detail.  For POST requests, it facilitates uploading of stratum methods
    if permitted via an environment variable. For any other HTTP method, it
    returns a 405 error.

    Parameters (for GET requests only):
        sm_code (str or None): The unique identifier for the stratum method
            being retrieved. If None, retrieves all stratum methods.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Can be 'true' or 'false'. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved stratum method(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    stratum_method_operator = StratumMethod(params)
    if request.method == 'POST':
        return stratum_method_operator.upload_stratum_method(request, params)
    elif request.method == 'GET':
        return stratum_method_operator.get_vegbank_resources(request, sm_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/strata", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/strata/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/strata", methods=['GET'])
@app.route("/taxon-observations/<vb_code>/strata", methods=['GET'])
@app.route("/taxon-importances/<vb_code>/strata", methods=['GET'])
def strata(vb_code):
    """
    Retrieve either an individual stratum or a collection of strata

    This function handles HTTP requests for strata. It currently supports only
    the GET method to retrieve records. If a POST request is made, it returns an
    error message indicating that POST is not supported. For any other HTTP
    method, it returns a 405 error.

    GET: If a valid stratum code is provided (e.g., `sr.1`), returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of stratum records
    associated with that resource. If no vb_code is provided, returns the full
    collection of stratum records. Collection responses may be further mediated
    by pagination parameters and other filtering query parameters.

    Parameters (for GET requests only):
        vb_code (str or None): The unique identifier for the stratum
            being retrieved. If None, retrieves all strata.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        with_nested (str, optional): Include nested fields?
            Only 'false' is defined for this method. Defaults to 'false'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved stratum/strata as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    stratum_operator = Stratum(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for strata."), 405
    elif request.method == 'GET':
        return stratum_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/references", defaults={'rf_code': None}, methods=['GET', 'POST'])
@app.route("/references/<rf_code>")
@require_scope(SCOPE_CONTRIBUTOR, methods=['POST'])
def references(rf_code, claims=None):
    """
    Retrieve either an individual reference or a collection.

    This function handles HTTP requests for references. It currently
    supports only the GET method to retrieve references. If a POST
    request is made, it returns an error message indicating that POST is
    not supported. For any other HTTP method, it returns a 405 error.

    If a valid rf_code is provided, returns the corresponding record if it
    exists. If no rf_code is provided, returns the full collection of
    concept records with pagination and field scope controlled by query
    parameters.

    Parameters:
        rf_code (str or None): The unique identifier for the reference
            being retrieved. If None, retrieves all references.

    GET Query Parameters:
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
            - 200: Successfully retrieved reference(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    reference_operator = Reference(params)
    if request.method == 'POST':
        file = request.files['file']
        to_return = None
        try:
            with connect(**params, row_factory=dict_row) as conn:
                rf_df = pd.read_parquet(file)
                to_return = reference_operator.upload_references(rf_df, conn)
                to_return = dry_run_check(conn, to_return, request)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(
                f"An error occurred during upload: {str(e)}"), 500
        return jsonify(to_return)
    elif request.method == 'GET':
        return reference_operator.get_vegbank_resources(request, rf_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/roles", defaults={'ar_code': None}, methods=['GET', 'POST'])
@app.route("/roles/<ar_code>")
@require_scope(SCOPE_ADMIN, methods=['POST'])
def roles(ar_code, claims=None):
    """
    Retrieve either an individual role or a collection.

    This function handles HTTP requests for VegBank roles. It currently supports
    only the GET method to retrieve roles. If a POST request is made, it returns
    an error message indicating that POST is not supported. For any other HTTP
    method, it returns a 405 error.

    If a valid ar_code is provided, returns the corresponding record if it
    exists. If no ar_code is provided, returns the full collection of role
    records with pagination and field scope controlled by query parameters.

    Parameters:
        ar_code (str or None): The unique identifier for the role
            being retrieved. If None, retrieves all roles.

    GET Query Parameters:
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
            - 200: Successfully retrieved user role(s) as JSON or Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    role_operator = Role(params)
    if request.method == 'POST':
        return role_operator.upload_all(request)
    elif request.method == 'GET':
        return role_operator.get_vegbank_resources(request, ar_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/named-places", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/named-places/<vb_code>")
def named_places(vb_code):
    """
    Retrieve either an individual named place record or a collection.

    This function handles HTTP requests for named places. It currently supports
    only the GET method to retrieve records. If a POST request is made, it
    returns an error message indicating that POST is not supported. For any
    other HTTP method, it returns a 405 error.

    GET: If a valid named place code is provided (e.g., `np.1`), returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of named place records
    associated with that resource. If no vb_code is provided, returns the full
    collection of named place records. Collection responses may be further
    mediated by pagination parameters and other filtering query parameters.

    Parameters:
        vb_code (str or None): The unique identifier for the named place
            being retrieved. If None, retrieves all named places.

    GET Query Parameters:
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
            - 200: Successfully retrieved named place(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    named_place_operator = NamedPlace(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for named-places."), 405
    elif request.method == 'GET':
        return named_place_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/user-datasets", defaults={'ds_code': None}, methods=['GET', 'POST'])
@app.route("/user-datasets/<ds_code>")
@require_scope(SCOPE_USER, methods=['POST'])
def user_datasets(ds_code, claims=None):
    """
    Retrieve either an individual user dataset listing or a collection.

    This function handles HTTP requests for user-defined datasets. It
    currently supports only the GET method to retrieve datasets. If a
    POST request is made, it returns an error message indicating that
    POST is not supported. For any other HTTP method, it returns a 405
    error.

    If a valid ds_code is provided, returns the corresponding record if it
    exists. If no ds_code is provided, returns the full collection of
    user dataset records with pagination and field scope controlled by
    query parameters.

    Parameters:
        ds_code (str or None): The unique identifier for the dataset
            being retrieved. If None, retrieves all datasets.

    GET Query Parameters:
        detail (str, optional): Level of detail for the response.
            Only 'full' is defined for this method. Defaults to 'full'.
        limit (int, optional): Maximum number of records to return.
            Defaults to 1000.
        offset (int, optional): Number of records to skip before starting
            to return records. Defaults to 0.
        create_parquet (str, optional): Whether to return data as Parquet
            rather than JSON. Accepts 'true' or 'false' (case-insensitive).
            Defaults to False.
    
    POST Query Parameters:
        dry_run (str, optional): If 'true', validates the dataset and returns any
            errors or created codes without committing to the database. Defaults to 'false'.
    
    POST Body:
        JSON object with the following structure:
        {
            "name": str,
            "description": str,
            "type": str,
            "data": dictionary where key is "observation" and values are list of vb_codes in those tables, 
                e.g.: "observation": ["ob.1", "ob.2", ...]
        }
        NOTE: We do not accept user datasets via this endpoint containing anything other than observations. 
            Anything else will result in an error. 

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved user dataset(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """

    if request.method == 'POST':
        try:
            to_return = UserDataset(params).upload_user_dataset_from_endpoint(request)
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(
                f"An error occurred during upload: {str(e)}"), 500
        return jsonify(to_return)
            
    elif request.method == 'GET':
        return UserDataset(params).get_vegbank_resources(request, ds_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/overview", methods=['GET'])
def overview():
    """
    Retrieve summary stats from VegBank

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved matching identifier
            - 400: Invalid parameters
            - 404: Not Found
    """
    return Overview(params).get_summary_stats(request)


@app.route("/identifiers/", defaults={'identifier_value': None}, methods=['GET'])
@app.route("/identifiers/<path:identifier_value>")
def identifiers(identifier_value):
    """
    Retrieve an individual record for a given citation or identifier value. 

    This function handles HTTP requests for identifying 'vb_codes' for historical
    accession codes, citations and other identifiers, supporting only the 'GET'
    method to retrieve an identifier.

    If an identifier is found for a given 'identifier_value', we return the
    corresponding record along with the 'identifier_value's 'vb_code'. If no record
    is found, we return a message stating so.

    Parameters:
        identifier_value (str or None): The identifier value that the user would like
            to search the 'identifiers' table for. Ex. "VB.TO.64992.VACCINIUMBOREAL"
    
    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved matching identifier
            - 400: Invalid parameters
            - 404: Not Found
    """
    if identifier_value is None:
        return jsonify_error_message("An identifier value or citation must be provided."), 400
    else:
        # Query the database for a match of the given identifier value
        try:
            # Handle potential whitespace
            identifier_value = identifier_value.strip()
            # Get result
            idsq = IdentifiersQueries(params)
            row = idsq.get_identifier_by_value(identifier_value)
            # If no result found, return error message
            if row is None:
                return (
                    jsonify_error_message(
                        f"Identifier value ({identifier_value}) not found."
                    ),
                    404,
                )
            else:
                # Add the 'vb_code' to result for convenience
                row["vb_code"] = f"{row['vb_table_code']}.{row['vb_record_id']}"
                return jsonify(row), 200
        # pylint: disable=W0718
        except Exception as e:
            print(traceback.format_exc())
            return (
                jsonify_error_message(
                    f"Unexpected error during identifier search: {str(e)}"
                ),
                500,
            )

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)
