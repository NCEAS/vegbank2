from flask import Flask, jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
from psycopg.rows import dict_row
import pandas as pd
import pyarrow 
import io
import time
import config

UPLOAD_FOLDER = '/vegbank2/uploads' #For future use with uploading parquet files if necessary
ALLOWED_EXTENSIONS = 'parquet'
QUERIES_FOLDER = 'queries/'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

params = config.params


@app.route("/")
def welcome_page():
    return "<h1>Welcome to the VegBank API</h1>"

@app.route("/plot-observations", defaults={'accession_code': None}, methods=['GET'])
@app.route("/plot-observations/<accession_code>", methods=['GET'])
def get_plot_observations(accession_code):
    detail = request.args.get("detail", "full")
    limit = int(request.args.get("limit", 1000))
    offset = int(request.args.get("offset", 0))
    
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
        elif detail == "full":
            with open(QUERIES_FOLDER + "/plot_observation/get_plot_observations_full.sql", "r") as file:
                sql = file.read()
        else:
            return jsonify({"error": "Invalid detail parameter. Use 'minimal' or 'full'."}), 400
    
    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, data)
            to_return["data"] = cur.fetchall()

            if(accession_code == None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()   
    return jsonify(to_return)

@app.route("/taxon-observations", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/taxon-observations/<accession_code>")
def get_taxon_observations(accession_code):
    detail = "full"
    limit = 100
    offset = 0
    num_taxa = 5
    if(request.args.get("detail") != None):
        detail = request.args.get("detail")
    if(request.args.get("num_taxa") != None):
        num_taxa = int(request.args.get("num_taxa"))
    if(request.args.get("limit") != None):
        limit = int(request.args.get("limit"))
    if(request.args.get("offset") != None):
        offset = int(request.args.get("offset"))
    data = (num_taxa, limit, offset, )
    
    count_sql = open(QUERIES_FOLDER + "/taxon_observation/get_top_taxa_count.sql", "r").read()
    countData = (num_taxa, )

    SQL = ""
    if(accession_code == None):
        SQL = open(QUERIES_FOLDER + "/taxon_observation/get_top_taxa_coverage.sql", "r").read()  
    else: #TODO This either needs to be an observation accession code, or a taxa one.
        SQL = open(QUERIES_FOLDER + "/taxon_observation/get_taxa_by_accession_code.sql", "r").read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SQL, data)
            to_return["data"] = cur.fetchall()
            print("number of records")

            #if(accession_code == None):
            #    cur.execute(count_sql, countData)
            #    to_return["count"] = cur.fetchall()[0]["count"]
            #else:
            #    to_return["count"] = len(to_return["data"])
        conn.close()      
    return jsonify(to_return)

@app.route("/community-classifications", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-classifications/<accession_code>")
def get_community_classifications(accession_code):
    detail = "full"
    limit = 1000
    offset = 0
    if(request.args.get("detail") != None):
        detail = request.args.get("detail")
    if(request.args.get("limit") != None):
        limit = int(request.args.get("limit"))
    if(request.args.get("offset") != None):
        offset = int(request.args.get("offset"))
    
    count_sql = open(QUERIES_FOLDER + "/community_classification/get_community_classifications_count.sql", "r").read()

    SQL = ""
    if(accession_code == None): 
        data = (limit, offset, )
        if(detail == "minimal"):
            SQL = open(QUERIES_FOLDER + "/community_classification/get_community_classifications_minimal.sql", "r").read()
        else:
            SQL = open(QUERIES_FOLDER + "/community_classification/get_community_classifications_full.sql", "r").read()
    else:
        SQL = open(QUERIES_FOLDER + "/community_classification/get_community_classification_by_accession_code.sql", "r").read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SQL, data)
            to_return["data"] = cur.fetchall()

            if(accession_code == None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

@app.route("/community-concepts", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/community-concepts/<accession_code>")
def get_community_concepts(accession_code):
    detail = "full"
    limit = 1000
    offset = 0
    if(request.args.get("detail") != None):
        detail = request.args.get("detail")
    if(request.args.get("limit") != None):
        limit = int(request.args.get("limit"))
    if(request.args.get("offset") != None):
        offset = int(request.args.get("offset"))

    count_sql = open(QUERIES_FOLDER + "/community_concept/get_community_concepts_count.sql", "r").read()
    SQL = ""
    if(accession_code == None): 
        SQL = open(QUERIES_FOLDER + "/community_concept/get_community_concepts_full.sql", "r").read()
        data = (limit, offset, )
    else:
        SQL = open(QUERIES_FOLDER + "/community_concept/get_community_concept_by_accession_code.sql", "r").read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SQL, data)
            to_return["data"] = cur.fetchall()

            if(accession_code == None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

@app.route("/parties", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/parties/<accession_code>")
def get_parties(accession_code):
    detail = "full"
    limit = 1000
    offset = 0
    if(request.args.get("detail") != None):
        detail = request.args.get("detail")
    if(request.args.get("limit") != None):
        limit = int(request.args.get("limit"))
    if(request.args.get("offset") != None):
        offset = int(request.args.get("offset"))
    count_sql = open(QUERIES_FOLDER + "/party/get_parties_count.sql", "r").read()
    SQL = ""
    if(accession_code == None): 
        SQL = open(QUERIES_FOLDER + "/party/get_parties_full.sql", "r").read()
        data = (limit, offset, )
    else:
        SQL = open(QUERIES_FOLDER + "/party/get_party_by_accession_code.sql", "r").read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SQL, data)
            to_return["data"] = cur.fetchall()

            if(accession_code == None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

@app.route("/projects", defaults={'accession_code': None}, methods=['GET', 'POST'])
@app.route("/projects/<accession_code>")
def get_projects(accession_code):
    detail = "full"
    limit = 1000
    offset = 0
    if(request.args.get("detail") != None):
        detail = request.args.get("detail")
    if(request.args.get("limit") != None):
        limit = int(request.args.get("limit"))
    if(request.args.get("offset") != None):
        offset = int(request.args.get("offset"))
    count_sql = open(QUERIES_FOLDER + "/project/get_projects_count.sql", "r").read()
    SQL = ""
    if(accession_code == None): 
        SQL = open(QUERIES_FOLDER + "/project/get_projects_full.sql", "r").read()
        data = (limit, offset, )
    else:
        SQL = open(QUERIES_FOLDER + "/project/get_project_by_accession_code.sql", "r").read()
        data = (accession_code, )

    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SQL, data)
            to_return["data"] = cur.fetchall()

            if(accession_code == None):
                cur.execute(count_sql)
                to_return["count"] = cur.fetchall()[0]["count"]
            else:
                to_return["count"] = len(to_return["data"])
        conn.close()    
    return jsonify(to_return)

#Shiny App Endpoints - These will be retired, leaving them here just until we're done testing. 
@app.route("/get_map_points")
def get_map_points():
    to_return = {}
    with psycopg.connect(**params, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_map_points.sql", "r").read() 
            cur.execute(SQL)
            to_return["data"] = cur.fetchall()
        conn.close()      
    return jsonify(to_return)

@app.route("/get_observation_table", defaults={'limit': None, 'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>", defaults={'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>/<offset>")
def get_observation_table(limit, offset):
    to_return = []
    if(limit == None):
        limit = 100
    if(offset == None):
        offset = 0
    limit = int(limit)
    offset = int(offset)
    startTime = time.perf_counter()
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            obsStartTime = time.perf_counter()
            SQL = open(QUERIES_FOLDER + "get_obs_table.sql", "r").read() 
            data = (limit, offset, )
            print(cur.mogrify(SQL, data))
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                to_return.append(dict(zip(columns, record)))
            obsEndTime = time.perf_counter()
            print(f"Observations queried and processed in: {obsEndTime - obsStartTime:0.4f} seconds")  
            for record in to_return:
                taxaStartTime = time.perf_counter()
                SQL = open(QUERIES_FOLDER + "get_top_5_taxa_coverage.sql", "r").read()
                data = (record['plot_id'], )
                cur.execute(SQL, data)
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
    to_return = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_observation_details.sql", "r").read() 
            data = (accession_code, )
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                to_return.append(dict(zip(columns, record)))
            if(len(to_return) != 0):
                taxa = []
                SQL = open(QUERIES_FOLDER + "/taxon_observation/get_taxa_for_observation.sql", "r").read() 
                data = (accession_code, )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    taxa.append(dict(zip(columns, record)))
                to_return[0].update({"taxa": taxa})
                communities = []
                SQL = open(QUERIES_FOLDER + "/community_concept/get_community_for_observation.sql", "r").read() 
                data = (accession_code, )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    communities.append(dict(zip(columns, record)))
                to_return[0].update({"communities": communities})
            else:
                to_return.append({"error": "No observation found with that accession code."})
        conn.close()      
    return jsonify(to_return)

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

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)