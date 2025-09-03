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
    plot_observation_operator = PlotObservation()
    return plot_observation_operator.get_observation_details(params, accession_code)

@app.route("/taxon-observations", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<accession_code>", methods=['GET'])
def taxon_observations(accession_code):
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
    party_operator = Party()
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for parties."), 405
    elif request.method == 'GET':
        return party_operator.get_parties(request, params, accession_code)

@app.route("/projects", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<accession_code>", methods=['GET'])
def projects(accession_code):
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

@app.route("/bulk-upload", methods=['POST'])
def bulk_upload():
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