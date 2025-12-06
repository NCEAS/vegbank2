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
from utilities import jsonify_error_message, allowed_file
from operators import (
    TaxonInterpretation,
    TaxonObservation,
    PlotObservation,
    Party,
    PlantConcept,
    CommunityClassification,
    CommunityInterpretation,
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


@app.route("/plot-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<vb_code>", methods=['GET'])
@app.route("/projects/<vb_code>/plot-observations", methods=['GET'])
@app.route("/parties/<vb_code>/plot-observations", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/plot-observations", methods=['GET'])
@app.route("/community-concepts/<vb_code>/plot-observations", methods=['GET'])
@app.route("/cover-methods/<vb_code>/plot-observations", methods=['GET'])
@app.route("/stratum-methods/<vb_code>/plot-observations", methods=['GET'])
def plot_observations(vb_code):
    """
    Retrieve either an individual plot observation or a collection, or
    upload a new set of plot observations.

    This function handles HTTP requests for plot observations, currently
    supporting POST and GET methods. For any other HTTP method, it returns a 405
    error.

    POST: Facilitates uploading of new plot observations as an attached Parquet
    file, if permitted via an environment variable.

    GET: If a valid plot observation code is provided (e.g., ob.1), returns the
    corresponding record if it exists. If a valid code for a different supported
    resource type is provided, returns the collection of plot observation
    records associated with that resource. If no vb_code is provided, returns
    the full collection of plot observation records. Collection responses may be
    further mediated by pagination parameters and other filtering query
    parameters.

    Parameters (for GET requests only):
        vb_code (str or None): The unique identifier for the plot observation
            being retrieved, or for a resource of a different type used to focus
            plot observation retrieval. If None, retrieves all plot observations.

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
        return plot_observation_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/taxon-observations", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/taxon-observations", methods=['GET'])
@app.route("/plant-concepts/<vb_code>/taxon-observations", methods=['GET'])
def taxon_observations(vb_code):
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
            observation concept being retrieved, or for a resource of a
            different type used to focus taxon observation retrieval. If
            None, retrieves all taxon observations.

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
        if allow_uploads is False:
            return jsonify_error_message("Uploads not allowed."), 403
        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400
        to_return = None
        try:
            with connect(**params, row_factory=dict_row) as conn:
                    to_return = taxon_observation_operator.upload_strata_definitions(file, conn)
            conn.close()
        except Exception as e:
            print(traceback.format_exc())
            return jsonify_error_message(f"An error occurred during upload: {str(e)}"), 500
        return to_return
    elif request.method == 'GET':
        return taxon_observation_operator.get_vegbank_resources(request, vb_code)
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
    if allow_uploads is False:
        return jsonify_error_message("Uploads not allowed."), 403
    if 'file' not in request.files:
        return jsonify_error_message("No file part in the request."), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify_error_message("No selected file."), 400
    if not allowed_file(file.filename):
        return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

    taxon_observation_operator = TaxonObservation(params)
    to_return = None
    try:
        with connect(**params, row_factory=dict_row) as conn:
            to_return = taxon_observation_operator.upload_strata_cover_data(file, conn)
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
def taxon_interpretations(vb_code):
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
        if allow_uploads is False:
            return jsonify_error_message("Uploads not allowed."), 403
        if 'file' not in request.files:
            return jsonify_error_message("No file part in the request."), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify_error_message("No selected file."), 400
        if not allowed_file(file.filename):
            return jsonify_error_message(
                "File type not allowed. Only Parquet files are accepted."), 400

        dry_run = request.args.get('dry_run', 'false').lower() == 'true'
        print("Dry Run: " + str(dry_run))

        taxon_observation_operator = TaxonObservation(params)
        to_return = None
        try:
            with connect(**params, row_factory=dict_row) as conn:
                to_return = taxon_observation_operator.upload_taxon_interpretations(file, conn)
                if dry_run:
                    conn.rollback()
                    message = "Dry run - rolling back transaction."
                    return jsonify({
                        "message": message,
                        "dry_run_data": to_return
                    })
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
def community_classifications(vb_code):
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
        return jsonify_error_message(
            "POST method is not supported for community_classifications."), 405
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
            "POST method is not supported for community_interpretations."), 405
    elif request.method == 'GET':
        return community_interpretation_operator.get_vegbank_resources(request,
                                                                       vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-concepts", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<vb_code>")
@app.route("/plot-observations/<vb_code>/community-concepts", methods=['GET'])
def community_concepts(vb_code):
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

    Parameters:
        vb_code (str or None): The unique identifier for the community concept
            being retrieved, or for a resource of a different type used to focus
            community concept retrieval. If None, retrieves all community
            concepts.

    GET Query Parameters:
        search (str, optional): Community name search query.
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
        return community_concept_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/plant-concepts", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/plant-concepts/<vb_code>")
@app.route("/plot-observations/<vb_code>/plant-concepts", methods=['GET'])
def plant_concepts(vb_code):
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

    Parameters:
        vb_code (str or None): The unique identifier for the plant
            concept being retrieved, or for a resource of a different type used
            to focus plant concept retrieval. If None, retrieves all plant
            concepts.

    GET Query Parameters:
        search (str, optional): Plant name search query.
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
        return plant_concept_operator.get_vegbank_resources(request, vb_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/parties", defaults={'vb_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<vb_code>", methods=['GET'])
@app.route("/plot-observations/<vb_code>/parties", methods=['GET'])
@app.route("/community-classifications/<vb_code>/parties", methods=['GET'])
@app.route("/projects/<vb_code>/parties", methods=['GET'])
def parties(vb_code):
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
        return party_operator.get_vegbank_resources(request, vb_code)
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
        search (str, optional): Project name search query.
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
