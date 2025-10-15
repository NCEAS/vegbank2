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
from utilities import jsonify_error_message, convert_to_parquet, allowed_file
from operators import (
    TaxonObservation,
    PlotObservation,
    Party,
    PlantConcept,
    CommunityClassification,
    CommunityConcept,
    CoverMethod,
    Project,
    StratumMethod,
    Reference,
)


UPLOAD_FOLDER = '/vegbank2/uploads' #For future use with uploading parquet files if necessary
QUERIES_FOLDER = 'queries/'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

params = {}
params['dbname'] = os.getenv('VB_DB_NAME')
params['user'] = os.getenv('VB_DB_USER')
params['host'] = os.getenv('VB_DB_HOST')
params['port'] = os.getenv('VB_DB_PORT')
params['password'] = os.getenv('VB_DB_PASS')

allow_uploads = os.getenv('VB_ALLOW_UPLOADS', 'false').lower() == 'true'

default_detail = "full"
default_limit = 1000
default_offset = 0


@app.route("/")
def welcome_page():
    return "<h1>Welcome to the VegBank API</h1>"


@app.route("/plot-observations", defaults={'ob_code': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<ob_code>", methods=['GET'])
def plot_observations(ob_code):
    """
    Retrieve either an individual plot observation or a collection, or
    upload a new set of plot observations.

    This function handles HTTP requests for plot observations. For GET requests,
    it retrieves plot observation details associated with a specified plot
    observation code (e.g., `ob.1`) or a paginated collection of all plot
    observations if no code is provided; see below for query parameters to
    support pagination and detail. For POST requests, it facilitates uploading
    of new plot observations if permitted via an environment variable. For any
    other HTTP method, it returns a 405 error.

    Parameters (for GET requests only):
        ob_code (str or None): The unique identifier for the plot observation
            being retrieved. If None, retrieves all plot observations.

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
            - 200: Successfully retrieved plot observation(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    plot_observation_operator = PlotObservation(params)
    if request.method == 'POST':
        if (allow_uploads is False):
            return jsonify_error_message("Uploads not allowed."), 403
        else:
            return plot_observation_operator.upload_plot_observations(request, params)
    elif request.method == 'GET':
        return plot_observation_operator.get_vegbank_resources(request, ob_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/get_observation_details/<ob_code>", methods=['GET'])
def get_observation_details(ob_code):
    """
    Retrieve details about a specific plot observation as identified by
    ob_code, returning information about the plot observation itself,
    associated taxon observations/interpretations, and associated community
    classifications/interpretations.

    Parameters:
        ob_code (str): The unique observation identifier.

    Returns:
        flask.Response: A Flask response object containing:
            - 200: Successfully retrieved plot observation details as JSON
            - 400: Invalid ob_code
            - 405: Unsupported HTTP method
    """
    plot_observation_operator = PlotObservation(params)
    return plot_observation_operator.get_observation_details(ob_code)


@app.route("/taxon-observations", defaults={'to_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<to_code>", methods=['GET'])
def taxon_observations(to_code):
    """
    Retrieve either an individual taxon observation or a collection.

    This function handles HTTP requests for taxon observations. It currently
    supports only the GET method to retrieve taxon observations. If a POST
    request is made, it returns an error message indicating that POST is not
    supported. For any other HTTP method, it returns a 405 error.

    If a valid to_code is provided, returns the corresponding record if it
    exists. If no to_code is provided, returns the full collection of
    taxon observation records with pagination and field scope controlled by
    query parameters.

    Parameters:
        to_code (str or None): The unique identifier for the taxon observation
            being retrieved. If None, retrieves all taxon observations.

    GET Query Parameters:
        num_taxa (int, optional): Number of taxa to return per plot observation,
            in descending order of max cover. Defaults to 5.
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
        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400
        return taxon_observation_operator.upload_strata_definitions(file)
    elif request.method == 'GET':
        return taxon_observation_operator.get_vegbank_resources(request, to_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-classifications", defaults={'cl_code': None}, methods=['GET', 'POST'])
@app.route("/community-classifications/<cl_code>", methods=['GET'])
def community_classifications(cl_code):
    """
    Retrieve either an individual community classification or a collection.

    This function handles HTTP requests for community classifications.
    It currently supports only the GET method to retrieve community
    classifications. If a POST request is made, it returns an error message
    indicating that POST is not supported. For any other HTTP method, it
    returns a 405 error.

    If a valid cl_code is provided, returns the corresponding record if it
    exists. If no cl_code is provided, returns the full collection of
    classification records with pagination and field scope controlled by
    query parameters.

    Parameters:
        cl_code (str or None): The unique identifier for the community
            classification being retrieved. If None, retrieves all
            classifications.

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
            - 200: Successfully retrieved community classification(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    community_classification_operator = CommunityClassification(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for community_classifications."), 405
    elif request.method == 'GET':
        return community_classification_operator.get_vegbank_resources(request, cl_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-concepts", defaults={'cc_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<cc_code>")
def community_concepts(cc_code):
    """
    Retrieve either an individual community concept or a collection.

    This function handles HTTP requests for community concepts. It currently
    supports only the GET method to retrieve community concepts. If a POST
    request is made, it returns an error message indicating that POST is
    not supported. For any other HTTP method, it returns a 405 error.

    If a valid cc_code is provided, returns the corresponding record if it
    exists. If no cc_code is provided, returns the full collection of
    concept records with pagination and field scope controlled by query
    parameters.

    Parameters:
        cc_code (str or None): The unique identifier for the community concept
            being retrieved. If None, retrieves all community concepts.

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
            - 200: Successfully retrieved community concept(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    community_concept_operator = CommunityConcept(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for community concepts."), 405
    elif request.method == 'GET':
        return community_concept_operator.get_vegbank_resources(request, cc_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/plant-concepts", defaults={'pc_code': None}, methods=['GET', 'POST'])
@app.route("/plant-concepts/<pc_code>")
def plant_concepts(pc_code):
    """
    Retrieve either an individual plant concept or a collection.

    This function handles HTTP requests for plant concepts. It currently
    supports only the GET method to retrieve plant concepts. If a POST
    request is made, it returns an error message indicating that POST is
    not supported. For any other HTTP method, it returns a 405 error.

    If a valid pc_code is provided, returns the corresponding record if it
    exists. If no pc_code is provided, returns the full collection of
    concept records with pagination and field scope controlled by query
    parameters.

    Parameters:
        pc_code (str or None): The unique identifier for the plant concept
            being retrieved. If None, retrieves all plant concepts.

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
            - 200: Successfully retrieved plant concept(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    plant_concept_operator = PlantConcept(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for plant concepts."), 405
    elif request.method == 'GET':
        return plant_concept_operator.get_vegbank_resources(request, pc_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/parties", defaults={'py_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<py_code>", methods=['GET'])
def parties(py_code):
    """
    Retrieve either an individual party or a collection.

    This function handles HTTP requests for parties. It currently
    supports only the GET method to retrieve parties. If a POST
    request is made, it returns an error message indicating that POST is
    not supported. For any other HTTP method, it returns a 405 error.

    If a valid py_code is provided, returns the corresponding record if it
    exists. If no py_code is provided, returns the full collection of
    concept records with pagination and field scope controlled by query
    parameters.

    Parameters:
        py_code (str or None): The unique identifier for the party
            being retrieved. If None, retrieves all parties.

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
            - 200: Successfully retrieved party record(s) as JSON or
                   Parquet (GET)
            - 400: Invalid parameters
            - 405: Unsupported HTTP method
    """
    party_operator = Party(params)
    if request.method == 'POST':
        return jsonify_error_message(
            "POST method is not supported for parties."), 405
    elif request.method == 'GET':
        return party_operator.get_vegbank_resources(request, py_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/projects", defaults={'pj_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<pj_code>", methods=['GET'])
def projects(pj_code):
    """
    Retrieve either an individual project or a collection, or upload a new set
    of projects.

    This function handles HTTP requests for projects. For GET requests, it
    retrieves project details associated with a specified project code (e.g.,
    `pj.1`) or a paginated collection of all projects if no code is provided;
    see below for query parameters to support pagination and detail. For POST
    requests, it facilitates uploading of new projects if permitted via an
    environment variable. For any other HTTP method, it returns a 405 error.

    Parameters (for GET requests only):
        pj_code (str or None): The unique identifier for the project being
            retrieved. If None, retrieves all projects.

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
            - 200: Successfully retrieved project(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    project_operator = Project(params)
    if request.method == 'POST':
        if (allow_uploads is False):
            return jsonify_error_message("Uploads not allowed."), 403
        else:
            return project_operator.upload_project(request, params)
    elif request.method == 'GET':
        return project_operator.get_vegbank_resources(request, pj_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/cover-methods", defaults={'cm_code': None}, methods=['GET', 'POST'])
@app.route("/cover-methods/<cm_code>")
def cover_methods(cm_code):
    """
    Retrieve either an individual cover method or a collection, or upload a new
    cover method.

    This function handles HTTP requests for cover methods. For GET requests, it
    retrieves cover method details associated with a specified cover method code
    (e.g., `cm.1`) or a paginated collection of all cover methods if no code is
    provided; see below for query parameters to support pagination and detail.
    For POST requests, it facilitates uploading of cover methods if permitted
    via an environment variable. For any other HTTP method, it returns a 405
    error.

    Parameters (for GET requests only):
        cm_code (str or None): The unique identifier for the cover method
            being retrieved. If None, retrieves all cover methods.

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
            - 200: Successfully retrieved cover method(s) as JSON or
                   Parquet (GET), or upload details as JSON (POST)
            - 400: Invalid parameters
            - 403: Uploads not allowed (POST only)
            - 405: Unsupported HTTP method
    """
    cover_method_operator = CoverMethod(params)
    if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads not allowed."), 403
        else:
            return cover_method_operator.upload_cover_method(request, params)
    elif request.method == 'GET':
        return cover_method_operator.get_vegbank_resources(request, cm_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/stratum-methods", defaults={'sm_code': None}, methods=['GET', 'POST'])
@app.route("/stratum-methods/<sm_code>", methods=['GET'])
def stratum_methods(sm_code):
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
        if(allow_uploads is False):
            return jsonify_error_message("Uploads not allowed."), 403
        else:
            return stratum_method_operator.upload_stratum_method(request, params)
    elif request.method == 'GET':
        return stratum_method_operator.get_vegbank_resources(request, sm_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/references", defaults={'rf_code': None}, methods=['GET', 'POST'])
@app.route("/references/<rf_code>")
def references(rf_code):
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
        return jsonify_error_message(
            "POST method is not supported for references."), 405
    elif request.method == 'GET':
        return reference_operator.get_vegbank_resources(request, rf_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/bulk-upload", methods=['POST'])
def bulk_upload():
    ''' This is an example endpoint for uploads with multiple parquet files. '''
    if 'files[]' not in request.files:
        return jsonify_error_message("No file part in the request."), 400

    files = request.files.getlist('files[]')
    response = {}
    for file in files:
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

        try:
            df = pd.read_parquet(file)
            print(f"DataFrame loaded with {len(df)} records.")
            # Here you would typically save the DataFrame to a database or process it further.
            response[file.filename] = {"message": "File uploaded successfully.", "num_records": len(df)}
        except Exception as e:
            response[file.filename] = {"error": f"An error occurred while processing the file: {str(e)}"}
    return jsonify(response), 200


if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)
