from flask import Flask, jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import numpy as np
import io
import time
import table_defs_config
import traceback
import os
UPLOAD_FOLDER = '/vegbank2/uploads' #For future use with uploading parquet files if necessary
ALLOWED_EXTENSIONS = 'parquet'
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
    if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return upload_plot_observations(request)
    elif request.method == 'GET':
        return get_plot_observations(accession_code, request)
    else: 
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405

def get_plot_observations(accession_code, request):
    create_parquet = request.args.get("create_parquet", "false").lower() == "true"
    detail = request.args.get("detail", default_detail)
    if detail not in ("minimal", "full"):
        return jsonify_error_message("When provided, 'detail' must be 'minimal' or 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
    
    with open(QUERIES_FOLDER + "/plot_observation/get_plot_observations_count.sql", "r") as file:
        count_sql = file.read()

    if accession_code is not None:
        sql = open(QUERIES_FOLDER + "/plot_observation/get_plot_observation_by_accession_code.sql", "r").read()
        data = (accession_code, )
    else:
        data = (limit, offset, )
        if detail == "minimal":
            with open(QUERIES_FOLDER + "/plot_observation/get_plot_observations_minimal.sql", "r") as file:
                sql = file.read()
        else:
            with open(QUERIES_FOLDER + "/plot_observation/get_plot_observations_full.sql", "r") as file:
                sql = file.read()
    
    to_return = {}
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        if(create_parquet is False):
            conn.row_factory=dict_row
        else:
            print("about to make plotobs parquet file")
            df_parquet = convert_to_parquet(sql, data, conn)
            print(df_parquet)
            conn.close()
            return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='plot_observations.parquet')
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if accession_code is None:
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()   
    return jsonify(to_return)

def upload_plot_observations(request):
    if 'file' not in request.files:
        return jsonify_error_message("No file part in the request."), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify_error_message("No selected file."), 400
    if not allowed_file(file.filename):
        return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

    plot_fields = table_defs_config.plot
    observation_fields = table_defs_config.observation

    to_return = {}
      
    try:
        df = pd.read_parquet(file)
        print(f"Plot Observation DataFrame loaded with {len(df)} records.")
        df.columns = map(str.lower, df.columns)
        #Checking if the user submitted any unsupported columns
        additional_columns = set(df.columns) - set(plot_fields) - set(observation_fields)
        if(len(additional_columns) > 0):
            return jsonify_error_message(f"Your data must only contain fields included in the plot observation schema. The following fields are not supported: {additional_columns} ")
        
        #We don't require every field to be present, so we will add any missing columns with empty data.
        #If the user omits a required field, like pl_code on an observation, the insert to the temp table will fail. 
        missing_plot_columns = set(plot_fields) - set(df.columns)
        for column in missing_plot_columns:
            df[column] = None  # Add missing columns with empty data
        missing_obs_columns = set(observation_fields) - set(df.columns)
        for column in missing_obs_columns:
            df[column] = None
        
         #These casts fix some common issues with the time fields. Not sure if this is a good plan long term, but I'm leaving it in for now. 
        df.replace({pd.NaT: None}, inplace=True)
        df.replace({np.nan: None}, inplace=True)
        print(df.columns)
        df['obsstartdate'] = pd.to_datetime(df['obsstartdate'])
        df['obsenddate'] = pd.to_datetime(df['obsenddate'])
        df['dateentered'] = pd.to_datetime(df['dateentered'])

        pl_input_df = df[plot_fields]
        pl_input_no_duplicates = pl_input_df.drop_duplicates() # We need to remove duplicates because there may be multiple observations for the same plot, and we only want to insert each plot once.
        pl_code_duplicates = pl_input_no_duplicates[pl_input_no_duplicates.duplicated(subset=['pl_code'])] 
        if(len(pl_code_duplicates) > 0):
            return jsonify_error_message(f"Plot codes cannot be used on more than one different plot. The following codes occur more than once: {pl_code_duplicates['pl_code']}")
        
        print(f"Plot data loaded with {len(pl_input_no_duplicates)} records")

        ob_input_df = df[observation_fields]

        ob_code_duplicates = ob_input_df[ob_input_df.duplicated(subset=['ob_code'])] 
        if(len(ob_code_duplicates) > 0):
            return jsonify_error_message(f"Obs codes cannot be used on more than one different observation. The following codes occur more than once: {ob_code_duplicates['obs_code']}")
        
        print(f"Observation data loaded with {len(ob_input_df)} records")
        pl_input_no_duplicates['submitter_surname'] = "test_surname" #This will need to be updated after authentication
        pl_input_no_duplicates['submitter_givenname'] = "test_givenname" #This will need to be updated after authentication
        pl_input_no_duplicates['submitter_email'] = "test@test_email.org" #This will need to be updated after authentication
        pl_inputs = list(pl_input_no_duplicates.itertuples(index=False, name=None))

        with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
            
            with conn.cursor() as cur:
                with conn.transaction():
                    
                    #Adding Plots to temp table, validating, then inserting into permanent table
                    with open(QUERIES_FOLDER + "/plot_observation/plot/create_plot_temp_table.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    with open(QUERIES_FOLDER + "/plot_observation/plot/insert_plots_to_temp_table.sql", "r") as file:
                        placeholders = ', '.join(['%s'] * len(pl_input_no_duplicates.columns))
                        sql = file.read().format(placeholders)

                    cur.executemany(sql, pl_inputs)
                    
                    print("about to run validate plots")
                    with open(QUERIES_FOLDER + "/plot_observation/plot/validate_plots.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    existing_plots = cur.fetchall()
                    print("existing records: " + str(existing_plots))
                    cur.nextset()
                    new_references = cur.fetchall()
                    print("new references: " + str(new_references))
                    
                    with open(QUERIES_FOLDER + "/plot_observation/plot/insert_plots_from_temp_table_to_permanent.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql)
                    inserted_plots = cur.fetchall()

                    if(len(inserted_plots) > 0): #This conditional provides for the case where no new plots were inserted, but existing plots were matched. In that case, we don't need to convert any user provided pl_codes into the new vegbank codes. 
                        inserted_plots_df = pd.DataFrame(inserted_plots)
                        inserted_plots_df = inserted_plots_df[['authorplotcode', 'pl_code']]
                        vb_pl_codes_df = pd.DataFrame(pl_input_no_duplicates[['pl_code', 'authorplotcode']])
                        vb_pl_codes_df.rename(columns={'pl_code': 'user_pl_code'}, inplace=True)
                        pl_codes_joined_df = pd.merge(vb_pl_codes_df, inserted_plots_df, how='left', on='authorplotcode')
                        user_pl_code_to_vb_pl_code = {}
                        for index, record in pl_codes_joined_df.iterrows():
                            user_pl_code_to_vb_pl_code[record['user_pl_code']] = record['pl_code']
                        ob_input_df['pl_code'] = ob_input_df['pl_code'].map(user_pl_code_to_vb_pl_code)

                    ob_input_df.replace({pd.NaT: None}, inplace=True)
                    obs_inputs = list(ob_input_df.itertuples(index=False, name=None))

                    #Adding Observations to temp table, validating, then inserting into permanent table
                    with open(QUERIES_FOLDER + "/plot_observation/observation/create_observation_temp_table.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    
                    with open(QUERIES_FOLDER + "/plot_observation/observation/insert_observations_to_temp_table.sql", "r") as file:
                        placeholders = ', '.join(['%s'] * len(ob_input_df.columns))
                        sql = file.read().format(placeholders)
                    cur.executemany(sql, obs_inputs)
                    
                    print("about to run validate observations")
                    with open(QUERIES_FOLDER + "/plot_observation/observation/validate_observations.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    existing_observations = cur.fetchall()
                    print("existing observations: " + str(existing_observations))
                    if(len(existing_observations) > 0):
                        raise ValueError("Some ob_codes provided already exist in vegbank. Please ensure you are only uploading new observations. Existing ob_codes: " + str(existing_observations))
                    
                    cur.nextset()
                    non_existant_plots = cur.fetchall()
                    print("non_existant_plots: " + str(non_existant_plots))
                    if(len(non_existant_plots) > 0):
                        raise ValueError("Some pl_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing plots. Non-existant pl_codes: " + str(non_existant_plots))
                    
                    cur.nextset()
                    non_existant_projects = cur.fetchall()
                    print("non_existant_projects: " + str(non_existant_projects))
                    if(len(non_existant_projects) > 0):
                        raise ValueError("Some pj_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing projects. Non-existant pj_codes: " + str(non_existant_projects))
                    
                    cur.nextset()
                    non_existant_cover_methods = cur.fetchall()
                    print("non_existant_cover_methods: " + str(non_existant_cover_methods))
                    if(len(non_existant_cover_methods) > 0):
                        raise ValueError("Some cm_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing cover methods. Non-existant cm_codes: " + str(non_existant_cover_methods))

                    cur.nextset()
                    non_existant_stratum_methods = cur.fetchall()
                    print("non_existant_stratum_methods: " + str(non_existant_stratum_methods))
                    if(len(non_existant_stratum_methods) > 0):
                        raise ValueError("Some sm_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing stratum methods. Non-existant sm_codes: " + str(non_existant_stratum_methods))
                    
                    cur.nextset()
                    non_existant_soil_taxa = cur.fetchall()
                    print("non_existant_soil_taxa: " + str(non_existant_soil_taxa))
                    if(len(non_existant_soil_taxa) > 0):
                        raise ValueError("Some st_codes provided do not exist in vegbank or the dataset provided. Please ensure you are only uploading observations for existing soil taxa. Non-existant st_codes: " + str(non_existant_soil_taxa))
                    
                    
                    with open(QUERIES_FOLDER + "/plot_observation/observation/insert_observations_from_temp_table_to_permanent.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql)
                    inserted_observations = cur.fetchall()
                    print("inserted records: " + str(inserted_observations))
                    if(len(inserted_observations) == 0):
                        raise ValueError("No new observations were found in the dataset provided.")
            
                    plot_ids = []
                    observation_ids = []
                    for record in inserted_plots:
                        plot_ids.append(record['plot_id'])
                    print("plot_ids: " + str(plot_ids))

                    for record in inserted_observations:
                        observation_ids.append(record['observation_id'])
                    print("observation_ids: " + str(observation_ids))
 
                    print("about to run create plot accession code")
                    with open(QUERIES_FOLDER + "/plot_observation/plot/create_plot_accession_codes.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql, (plot_ids, ))
                    new_pl_codes = cur.fetchall()

                    print("about to run create observation accession code")
                    with open(QUERIES_FOLDER + "/plot_observation/observation/create_observation_accession_codes.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql, (observation_ids, ))
                    new_ob_codes = cur.fetchall()
                    
                    to_return_plots = []
                    if(len(new_pl_codes) > 0):
                        pl_codes_df = pd.DataFrame(new_pl_codes)
                        pl_input_df['authorplotcode'] = pl_input_df['authorplotcode'].astype(str)
                        pl_codes_df['authorplotcode'] = pl_codes_df['authorplotcode'].astype(str)
                        joined_pl_df = pd.merge(pl_codes_df, pl_input_no_duplicates, on='authorplotcode', how='left')
                        for index, record in joined_pl_df.iterrows():
                            to_return_plots.append({
                                "user_code": record['pl_code'], 
                                "pl_code": record['accessioncode'],
                                "authorplotcode": record['authorplotcode'],
                                "action":"inserted"
                            })
                    else:  
                        joined_pl_df = pd.DataFrame()
                    for record in existing_plots:
                        to_return_plots.append({
                            "user_code": record["pl_code"],
                            "pl_code": record['pl_code'],
                            "authorplotcode": record['authorplotcode'],
                            "action":"matched"
                        })

                    ob_codes_df = pd.DataFrame(new_ob_codes)
                    ob_input_df['authorobscode'] = ob_input_df['authorobscode'].astype(str)
                    ob_codes_df['authorobscode'] = ob_codes_df['authorobscode'].astype(str)
                    joined_ob_df = pd.merge(ob_codes_df, ob_input_df, on='authorobscode', how='left')

                    to_return_observations = []
                    for index, record in joined_ob_df.iterrows():
                        to_return_observations.append({
                            "user_code": record['ob_code'], 
                            "ob_code": record['accessioncode'],
                            "authorobscode": record['authorobscode'],
                            "action":"inserted"
                        })
                    for record in existing_observations:
                        to_return_observations.append({
                            "user_code": record["ob_code"],
                            "ob_code": record['ob_code'],
                            "authorobscode": record['authorobscode'],
                            "action":"matched"
                        })
                    to_return["resources"] = {
                        "pl": to_return_plots,
                        "ob": to_return_observations
                    }
                    to_return["counts"] = {
                        "pl":{
                            "inserted": len(joined_pl_df),
                            "matched": len(existing_plots)
                        },
                        "ob":{
                            "inserted": len(joined_ob_df),
                            "matched": len(existing_observations)
                        }
                    }
        conn.close()      

        return jsonify(to_return)
    except Exception as e:
        traceback.print_exc()
        return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500

@app.route("/taxon-observations", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<accession_code>")
def get_taxon_observations(accession_code):
    detail = request.args.get("detail", default_detail)
    if detail not in ("minimal", "full"):
        return jsonify_error_message("When provided, 'detail' must be 'minimal' or 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
        num_taxa = int(request.args.get("num_taxa", 5))  # Default to 5 if not specified
    except ValueError:
        return jsonify_error_message("When provided, 'offset' 'numTaxa' and 'limit' must be non-negative integers."), 400
    
    data = (num_taxa, limit, offset, )
    
    with open(QUERIES_FOLDER + "/taxon_observation/get_top_taxa_count.sql", "r") as file:
        count_sql = file.read()
    countData = (num_taxa, )

    sql = ""
    if(accession_code is None):
        with open(QUERIES_FOLDER + "/taxon_observation/get_top_taxa_coverage.sql", "r") as file:
            sql = file.read()
    else: #TODO This either needs to be an observation accession code, or a taxa one.
        with open(QUERIES_FOLDER + "/taxon_observation/get_taxa_by_accession_code.sql", "r") as file:
            sql = file.read()
            data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()
            print("number of records")

            #if(accession_code is None):
            #    cur.execute(count_sql, countData)
            #    to_return["count"] = cur.fetchall()[0]["count"]
            #else:
            #    to_return["count"] = len(to_return["data"])
        conn.close()      
    return jsonify(to_return)

@app.route("/community-classifications", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-classifications/<accession_code>")
def get_community_classifications(accession_code):
    detail = request.args.get("detail", default_detail)
    if detail not in ("minimal", "full"):
        return jsonify_error_message("When provided, 'detail' must be 'minimal' or 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
    
    with open(QUERIES_FOLDER + "/community_classification/get_community_classifications_count.sql", "r") as file:
        count_sql = file.read()

    sql = ""
    if(accession_code is None): 
        data = (limit, offset, )
        if(detail == "minimal"):
            with open(QUERIES_FOLDER + "/community_classification/get_community_classifications_minimal.sql", "r") as file:
                sql = file.read()
        else:
            with open(QUERIES_FOLDER + "/community_classification/get_community_classifications_full.sql", "r") as file:
                sql = file.read()
    else:
        with open(QUERIES_FOLDER + "/community_classification/get_community_classification_by_accession_code.sql", "r") as file:
            sql = file.read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if(accession_code is None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

@app.route("/community-concepts", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<accession_code>")
def get_community_concepts(accession_code):
    detail = request.args.get("detail", default_detail)
    if detail not in ("full"):
        return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

    with open(QUERIES_FOLDER + "/community_concept/get_community_concepts_count.sql", "r") as file:
        count_sql = file.read()

    sql = ""
    if(accession_code is None): 
        with open(QUERIES_FOLDER + "/community_concept/get_community_concepts_full.sql", "r") as file:
            sql = file.read()
        data = (limit, offset, )
    else:
        with open(QUERIES_FOLDER + "/community_concept/get_community_concept_by_accession_code.sql", "r") as file:
            sql = file.read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if(accession_code is None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

@app.route("/parties", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<accession_code>")
def parties(accession_code):
    if request.method == 'POST':
        return jsonify_error_message("POST method is not supported for parties."), 405
    elif request.method == 'GET':
        return get_parties(accession_code, request)

def get_parties(accession_code, request):
    detail = request.args.get("detail", default_detail)
    if detail not in ("full"):
        return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

    with open(QUERIES_FOLDER + "/party/get_parties_count.sql", "r") as file:
        count_sql = file.read()

    sql = ""
    if(accession_code is None): 
        with open(QUERIES_FOLDER + "/party/get_parties_full.sql", "r") as file:
            sql = file.read()
        data = (limit, offset, )
    else:
        with open(QUERIES_FOLDER + "/party/get_party_by_accession_code.sql", "r") as file:
            sql = file.read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if(accession_code is None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

def upload_parties(request):
    return jsonify_error_message("POST method is not supported for parties."), 405

@app.route("/projects", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<accession_code>")
def projects(accession_code):
   if request.method == 'POST':
        if(allow_uploads is False):
            return jsonify_error_message("Uploads are not allowed on this server."), 403
        else:
            return upload_project(request) 
   elif request.method == 'GET':
        return get_projects(accession_code, request)
   else:
        return jsonify_error_message("Method not allowed. Use GET or POST."), 405

def get_projects(accession_code, request):
    create_parquet = request.args.get("create_parquet", "false").lower() == "true"
    detail = request.args.get("detail", default_detail)
    if detail not in ("full"):
        return jsonify_error_message("When provided, 'detail' must be 'full'."), 400
    try:
        limit = int(request.args.get("limit", default_limit))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400

    with open(QUERIES_FOLDER + "/project/get_projects_count.sql", "r") as file:
        count_sql = file.read()

    sql = ""
    if(accession_code is None): 
        with open(QUERIES_FOLDER + "/project/get_projects_full.sql", "r") as file:
            sql = file.read()
        data = (limit, offset, )
    else:
        with open(QUERIES_FOLDER + "/project/get_project_by_accession_code.sql", "r") as file:
            sql = file.read()
        data = (accession_code, )
    to_return = {}
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        if(create_parquet is False):
            conn.row_factory=dict_row
        else:
            df_parquet = convert_to_parquet(sql, data, conn)
            conn.close()
            return send_file(io.BytesIO(df_parquet), mimetype='application/octet-stream', as_attachment=True, download_name='projects.parquet')
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if(accession_code is None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

def upload_project(request):
    if 'file' not in request.files:
        return jsonify_error_message("No file part in the request."), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify_error_message("No selected file."), 400
    if not allowed_file(file.filename):
        return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400

    to_return = {}
    try:
        df = pd.read_parquet(file)
        print(f"DataFrame loaded with {len(df)} records.")

        #Adding these for testing, they should be removed at launch. 
        if('project_id' in df.columns):
            df.drop(columns=['project_id'], inplace=True)
        if('obscount' in df.columns):
            df.drop(columns=['obscount'], inplace=True)
        if('lastplotaddeddate' in df.columns):
            df.drop(columns=['lastplotaddeddate'], inplace=True)

        df.replace({pd.NaT: None}, inplace=True)
        inputs = list(df.itertuples(index=False, name=None))

        with psycopg.connect(**params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
            
            with conn.cursor() as cur:
                with conn.transaction():
                    
                    with open(QUERIES_FOLDER + "/project/create_project_temp_table.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    with open(QUERIES_FOLDER + "/project/insert_projects_to_temp_table.sql", "r") as file:
                        sql = file.read()
                    cur.executemany(sql, inputs)

                    print("about to run validate projects")
                    with open(QUERIES_FOLDER + "/project/validate_projects.sql", "r") as file:
                        sql = file.read() 
                    cur.execute(sql)
                    existing_records = cur.fetchall()
                    print("existing records: " + str(existing_records))

                    with open(QUERIES_FOLDER + "/project/insert_projects_from_temp_table_to_permanent.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql)
                    inserted_records = cur.fetchall()
                    print("inserted records: " + str(inserted_records))

                    project_ids = []
                    for record in inserted_records:
                        project_ids.append(record['project_id'])
                    print("project_ids: " + str(project_ids))

                    print("about to run create accession code")
                    with open(QUERIES_FOLDER + "/project/create_project_accession_codes.sql", "r") as file:
                        sql = file.read()
                    cur.execute(sql, (project_ids, ))
                    new_pj_codes = cur.fetchall()

                    pj_codes_df = pd.DataFrame(new_pj_codes)
                    print("pj_codes_df" + str(pj_codes_df))
                    df['projectname'] = df['projectname'].astype(str)
                    pj_codes_df['projectname'] = pj_codes_df['projectname'].astype(str)
                    print("project name type: " + str(df['projectname'].dtype))
                    print("pj_code project name type: " + str(pj_codes_df['projectname'].dtype))

                    joined_df = pd.merge(df, pj_codes_df, on='projectname')
                    print("----------------------------------------")
                    print(str(joined_df))


                    to_return_projects = []
                    for index, record in joined_df.iterrows():
                        to_return_projects.append({
                            "user_code": record['projectaccessioncode'], 
                            "pj_code": record['accessioncode'],
                            "projectname": record['projectname'],
                            "action":"inserted"
                        })
                    for record in existing_records:
                        to_return_projects.append({
                            "user_code": record["user_code"],
                            "pj_code": record['user_code'],
                            "projectname": record['projectname'],
                            "action":"matched"
                        })
                    to_return["resources"] = {
                        "pj": to_return_projects
                    }
                    to_return["counts"] = {
                        "pj":{
                            "inserted": len(joined_df),
                            "matched": len(existing_records)
                        }
                    }
                    
        conn.close()      

        return jsonify(to_return)
    except Exception as e:
        traceback.print_exc()
        return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500

#Shiny App Endpoints - These will be retired, leaving them here just until we're done testing. 
@app.route("/get_map_points")
def get_map_points():
    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            with open(QUERIES_FOLDER + "get_map_points.sql", "r") as file:
                sql = file.read()
            cur.execute(sql)
            to_return["data"] = cur.fetchall()
        conn.close()      
    return jsonify(to_return)

@app.route("/get_observation_table", defaults={'limit': None, 'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>", defaults={'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>/<offset>")
def get_observation_table(limit, offset):
    to_return = []
    try:
        limit = int(request.args.get("limit", 100))
        offset = int(request.args.get("offset", default_offset))
    except ValueError:
        return jsonify_error_message("When provided, 'offset' and 'limit' must be non-negative integers."), 400
    startTime = time.perf_counter()
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            obsStartTime = time.perf_counter()
            with open(QUERIES_FOLDER + "get_obs_table.sql", "r") as file:
                sql = file.read() 
            data = (limit, offset, )
            cur.execute(sql, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                to_return.append(dict(zip(columns, record)))
            obsEndTime = time.perf_counter()
            print(f"Observations queried and processed in: {obsEndTime - obsStartTime:0.4f} seconds")  
            with open(QUERIES_FOLDER + "get_top_5_taxa_coverage.sql", "r") as file:
                    sql = file.read()
            for record in to_return:
                taxaStartTime = time.perf_counter()
                data = (record['plot_id'], )
                cur.execute(sql, data)
                columns = [desc[0] for desc in cur.description]
                taxa = []
                for taxaRecord in cur.fetchall():
                    taxa.append(dict(zip(columns, taxaRecord)))
                record.update({"taxa": taxa})
                taxaEndTime = time.perf_counter()
                print(f"Taxa queried and processed in: {taxaEndTime - taxaStartTime:0.4f} seconds")  
        conn.close() 
    endTime = time.perf_counter()
    print(f"Observation table queried and processed in: {endTime - startTime:0.4f} seconds")     
    return jsonify(to_return)

@app.route("/get_observation_details/<accession_code>")
def get_observation_details(accession_code):
    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            with open(QUERIES_FOLDER + "get_observation_details.sql", "r") as file:
                sql = file.read() 
            data = (accession_code, )
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()
            to_return["count"] = len(to_return["data"])
            print(to_return)
            if(len(to_return["data"]) != 0):
                taxa = []
                with open(QUERIES_FOLDER + "/taxon_observation/get_taxa_for_observation.sql", "r") as file:
                    sql = file.read() 
                data = (accession_code, )
                cur.execute(sql, data)
                taxa = cur.fetchall()
                to_return["data"][0].update({"taxa": taxa})
                communities = []
                with open(QUERIES_FOLDER + "/community_concept/get_community_for_observation.sql", "r") as file:
                    sql = file.read() 
                data = (accession_code, )
                cur.execute(sql, data)
                communities = cur.fetchall()
                to_return["data"][0].update({"communities": communities})
        conn.close()      
    return jsonify(to_return)

#Upload Endpoints

@app.route("/upload_parquet", methods=['POST'])
def upload_parquet():
    if 'file' not in request.files:
        return jsonify_error_message("No file part in the request."), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify_error_message("No selected file."), 400
    if not allowed_file(file.filename):
        return jsonify_error_message("File type not allowed. Only Parquet files are accepted."), 400
    
    try:
        df = pd.read_parquet(file)
        print(f"DataFrame loaded with {len(df)} records.")
        # Here you would typically save the DataFrame to a database or process it further.
        return jsonify({"message": "File uploaded successfully.", "num_records": len(df)}), 200
    except Exception as e:
        return jsonify_error_message(f"An error occurred while processing the file: {str(e)}"), 500

@app.route("/upload_parquet_multiple", methods=['POST'])
def upload_parquet_multiple():
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



#Utilities
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
if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)