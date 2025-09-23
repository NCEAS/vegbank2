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
from operators.TaxonObservation import TaxonObservation
from operators.PlotObservation import PlotObservation
from operators.Party import Party
from operators.CommunityClassification import CommunityClassification
from operators.CommunityConcept import CommunityConcept
from operators.CoverMethod import CoverMethod
from operators.Project import Project
from operators.StratumMethod import StratumMethod


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


@app.route("/plot-observations", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<accession_code>", methods=['GET'])
def plot_observations(accession_code):
    '''
    Handles creation and return of plots and observations.

    This function supports both GET and POST requests. For POST requests, it allows 
    the uploading of plot observations if uploads are permitted via an environment variable. For GET requests, 
    it retrieves plot observations associated with the specified accession code. If no accession code is provided, 
    returns a paginated json object of all plot observations. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    Parameters:
        accession_code (str): The accession code for which plot observations are 
                            to be retrieved. Defaults to None.

    Returns:
        Response: A JSON response containing either the plot observations or an 
                error message, along with the appropriate HTTP status code.

    Methods:
        - POST: Uploads plot observations if allowed.
        - GET: Retrieves plot observations based on the accession code.

    Raises:
        403: If uploads are not allowed on the server.
        405: If the request method is neither GET nor POST.
    '''
    plot_observation_operator = PlotObservation()
    if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return plot_observation_operator.upload_plot_observations(request, params)
    elif request.method == 'GET':
        return plot_observation_operator.get_plot_observations(request, params, accession_code)
    else: 
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/get_observation_details/<accession_code>", methods=['GET'])
def get_observation_details(accession_code):
    '''
    Returns detailed information about a specific observation based on the provided accession code.
    Parameters:
        accession_code (str): The accession code of the observation to retrieve details for.
    Returns:
        Response: A JSON response containing the observation details or an error message.
    Methods: 
        - GET: Retrieves observation details based on the accession code.
    Raises: 
        405: If the request method is not GET.
    '''
    plot_observation_operator = PlotObservation()
    return plot_observation_operator.get_observation_details(params, accession_code)


@app.route("/taxon-observations", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<accession_code>", methods=['GET'])
def taxon_observations(accession_code):
    '''
    Retrieve taxon observations based on the provided accession code. 
    If no accession code is provided, return a paginated json objsect 
    of all taxon observations. This function supports URL parameters for detail level, 
    limit, offset, and the number of top taxa, that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0 num_taxa: 5.

    This function handles HTTP requests for taxon observations. It supports 
    only the GET method to retrieve taxon observations. If a POST request is made, 
    it returns an error message indicating that the POST method is not supported. 
    For any other HTTP methods, it returns a method not allowed error.

    Parameters:
        accession_code (str): The unique identifier for the taxon 
        observation to be retrieved.

    Returns:
        Response: A JSON response containing the taxon observations or an 
        error message with the appropriate HTTP status code.
    
    Raises: 
        405: If the request method is neither GET nor POST.
    '''
    taxon_observation_operator = TaxonObservation()
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for taxon observations."), 405
    elif request.method == 'GET':
        return taxon_observation_operator.get_taxon_observations(request, params, accession_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-classifications", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-classifications/<accession_code>", methods=['GET'])
def community_classifications(accession_code):
    '''
    Retrieve community classifications based on the provided accession code. 
    If no accession code is provided, return a paginated json objsect 
    of all community classifications. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    This function handles HTTP requests for community classifications. It supports 
    only the GET method to retrieve community classifications. If a POST request is made, 
    it returns an error message indicating that the POST method is not supported. 
    For any other HTTP methods, it returns a method not allowed error.

    Parameters:
        accession_code (str): The unique identifier for the community classification to be retrieved.

    Returns:
        Response: A JSON response containing the community classifications or an 
        error message with the appropriate HTTP status code.
    
    Raises: 
        405: If the request method is neither GET nor POST.
    '''
    community_classification_operator = CommunityClassification()
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for community classifications."), 405
    elif request.method == 'GET':
        return community_classification_operator.get_community_classifications(request, params, accession_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/community-concepts", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<accession_code>", methods=['GET'])
def community_concepts(accession_code):
    '''
    Retrieve community concepts based on the provided accession code. 
    If no accession code is provided, return a paginated json objsect 
    of all community concepts. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    This function handles HTTP requests for community concepts. It supports 
    only the GET method to retrieve community concepts. If a POST request is made, 
    it returns an error message indicating that the POST method is not supported. 
    For any other HTTP methods, it returns a method not allowed error.

    Parameters:
        accession_code (str): The unique identifier for the community concepts to be retrieved.

    Returns:
        Response: A JSON response containing the community concepts or an 
        error message with the appropriate HTTP status code.
    
    Raises: 
        405: If the request method is neither GET nor POST.
    '''
    community_concept_operator = CommunityConcept()
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for community concepts."), 405
    elif request.method == 'GET':
        return community_concept_operator.get_community_concepts(request, params, accession_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/parties", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<accession_code>", methods=['GET'])
def parties(accession_code):
    '''
    Retrieve parties based on the provided accession code. 
    If no accession code is provided, return a paginated json objsect 
    of all parties. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    This function handles HTTP requests for parties. It supports 
    only the GET method to retrieve parties. If a POST request is made, 
    it returns an error message indicating that the POST method is not supported. 
    For any other HTTP methods, it returns a method not allowed error.

    Parameters:
        accession_code (str): The unique identifier for the parties to be retrieved.

    Returns:
        Response: A JSON response containing the parties or an 
        error message with the appropriate HTTP status code.
    
    Raises: 
        405: If the request method is neither GET nor POST.
    '''
    party_operator = Party()
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for parties."), 405
    elif request.method == 'GET':
        return party_operator.get_parties(request, params, accession_code)


@app.route("/projects", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<accession_code>", methods=['GET'])
def projects(accession_code):
   '''
    Handles creation and return of projects.

    This function supports both GET and POST requests. For POST requests, it allows 
    the uploading of projects if uploads are permitted via an environment variable. For GET requests, 
    it retrieves projects associated with the specified accession code. If no accession code is provided, 
    returns a paginated json object of all projects. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    Parameters:
        accession_code (str): The accession code for the project 
                            to be retrieved. Defaults to None.

    Returns:
        Response: A JSON response containing either the projects or an 
                error message, along with the appropriate HTTP status code.

    Methods:
        - POST: Uploads projects if allowed.
        - GET: Retrieves project based on the accession code.

    Raises:
        403: If uploads are not allowed on the server.
        405: If the request method is neither GET nor POST.
    '''
   project_operator = Project()
   if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return project_operator.upload_project(request, params) 
   elif request.method == 'GET':
        return project_operator.get_projects(request, params, accession_code)
   else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/cover-methods", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/cover-methods/<accession_code>")
def cover_methods(accession_code):
    '''
    Handles creation and return of cover methods.

    This function supports both GET and POST requests. For POST requests, it allows 
    the uploading of cover methods if uploads are permitted via an environment variable. For GET requests, 
    it retrieves cover methods associated with the specified accession code. If no accession code is provided, 
    returns a paginated json object of all cover methods. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    Parameters:
        accession_code (str): The accession code for the cover method 
                            to be retrieved. Defaults to None.
    URL Parameters:
        detail (str): Level of detail for the response. Currently only supports "full".
        limit (int): Maximum number of records to return. Defaults to 1000.
        offset (int): Number of records to skip before starting to return records. Defaults to 0.

    Returns:
        Response: A JSON response containing either the cover methods or an 
                error message, along with the appropriate HTTP status code.

    Methods:
        - POST: Uploads cover methods if allowed.
        - GET: Retrieves cover method based on the accession code.

    Raises:
        403: If uploads are not allowed on the server.
        405: If the request method is neither GET nor POST.
    '''
    cover_method_operator = CoverMethod()
    if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return cover_method_operator.upload_cover_method(request, params) 
    elif request.method == 'GET':
        return cover_method_operator.get_cover_method(request, params, accession_code)
    else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405


@app.route("/stratum-methods", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/stratum-methods/<accession_code>", methods=['GET'])
def stratum_methods(accession_code):
    '''
    Handles creation and return of stratum methods.

    This function supports both GET and POST requests. For POST requests, it allows 
    the uploading of stratum methods if uploads are permitted via an environment variable. For GET requests, 
    it retrieves stratum methods associated with the specified accession code. If no accession code is provided, 
    returns a paginated json object of all stratum methods. This function supports URL parameters for detail level, 
    limit, and offset that are parsed from the request. Default values are used if parameters are not provided: 
    detail: "full", limit: 1000, offset: 0.

    Parameters:
        accession_code (str): The accession code for the stratum method 
                            to be retrieved. Defaults to None.

    Returns:
        Response: A JSON response containing either the stratum methods or an 
                error message, along with the appropriate HTTP status code.

    Methods:
        - POST: Uploads stratum methods if allowed.
        - GET: Retrieves stratum method based on the accession code.

    Raises:
        403: If uploads are not allowed on the server.
    '''
    stratum_method_operator = StratumMethod()
    if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return stratum_method_operator.upload_stratum_method(request, params)
    elif request.method == 'GET':
        return stratum_method_operator.get_stratum_method(request, params, accession_code)
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