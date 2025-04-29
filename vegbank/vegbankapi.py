from flask import Flask, jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
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


@app.route("/plot-observations", defaults={'accessioncode': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<accessioncode>")
def get_observation(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            if(accessioncode == None):
                with conn.cursor() as cur:
                    SQL = "SELECT * FROM observation INNER JOIN plot ON plot.plot_id = observation.plot_id where plot.confidentialitystatus < 4;"
                    cur.execute(SQL)
                    columns = [desc[0] for desc in cur.description]
                    for record in cur.fetchall():
                        toReturn.append(dict(zip(columns, record)))
                conn.close()   
            else:
                with conn.cursor() as cur:
                    plot_observations = []
                    SQL1 = "SELECT * FROM observation INNER JOIN plot ON plot.plot_id = observation.plot_id where plot.confidentialitystatus < 4 AND observation.accessionCode = %s;"
                    data = (accessioncode, )
                    cur.execute(SQL1, data)
                    columns = [desc[0] for desc in cur.description]
                    for record in cur.fetchall():
                        toReturn.append(dict(zip(columns, record)))
                conn.close()   
    return jsonify(toReturn)

@app.route("/plots", defaults={'accessioncode': None}, methods=['GET', 'POST'])
@app.route("/plots/<accessioncode>")
def get_all_plots(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        if(accessioncode == None):
            with conn.cursor() as cur:
                SQL = "SELECT * from plot where confidentialitystatus < 4;"
                cur.execute(SQL)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()   
        else:
            with conn.cursor() as cur:
                SQL = "SELECT * from plot where confidentialitystatus < 4 AND accessionCode = %s;"
                data = (accessioncode, )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()    
    return jsonify(toReturn)

@app.route("/taxon_observations", defaults={'accessioncode': None}, methods=['GET', 'POST'])
@app.route("/taxon_observations/<accessioncode>")
def get_taxon_observations(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        if(accessioncode == None):
            with conn.cursor() as cur:
                SQL = "SELECT * FROM taxonObservation;"
                cur.execute(SQL)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()   
        else:
            with conn.cursor() as cur:
                SQL = "SELECT * FROM taxonObservation where accessionCode = %s;"
                data = (accessioncode, )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()    
    return jsonify(toReturn)

@app.route("/comm_concepts", defaults={'accessioncode': None}, methods=['GET', 'POST'])
@app.route("/comm_concepts/<accessioncode>")
def get_comm_concepts(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        if(accessioncode == None):
            with conn.cursor() as cur:
                SQL = "SELECT commName.commName, commConcept.commDescription FROM commConcept    LEFT JOIN commName on commName.commname_ID = commConcept.commname_ID;"
                cur.execute(SQL)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()   
        else:
            with conn.cursor() as cur:
                SQL = "SELECT commName.commName, commConcept.commDescription FROM commConcept    LEFT JOIN commName on commName.commname_ID = commConcept.commname_ID    WHERE commConcept.accessionCode = %s;"
                data = (accessioncode, )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()    
    return jsonify(toReturn)

#Shiny App Endpoints
@app.route("/get_map_points")
def get_map_points():
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_map_points.sql", "r").read() 
            cur.execute(SQL)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
        conn.close()      
    return jsonify(toReturn)

@app.route("/get_map_points_parquet")
def get_map_points_parquet():
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        SQL = open(QUERIES_FOLDER + "get_map_points.sql", "r").read() 
        toReturn = convert_to_parquet(SQL, conn, "map_points.parquet")
        conn.close()      
    return send_file(
        io.BytesIO(toReturn),
        mimetype='application/octet-stream',
        as_attachment=True,
        download_name='map_points.parquet'
    )

@app.route("/get_observation_details/<accessioncode>")
def get_observation_details(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_observation_details.sql", "r").read() 
            data = (accessioncode, )
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
            taxa = []
            SQL = open(QUERIES_FOLDER + "get_taxa_for_observation.sql", "r").read() 
            data = (accessioncode, )
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                taxa.append(dict(zip(columns, record)))
            toReturn[0].update({"taxa": taxa})
            communities = []
            SQL = open(QUERIES_FOLDER + "get_community_for_observation.sql", "r").read() 
            data = (accessioncode, )
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                communities.append(dict(zip(columns, record)))
            toReturn[0].update({"communities": communities})
        conn.close()      
    return jsonify(toReturn)

@app.route("/get_observation_table", defaults={'limit': None, 'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>", defaults={'offset': None}, methods=['GET'])
@app.route("/get_observation_table/<limit>/<offset>")
def get_observation_table(limit, offset):
    toReturn = []
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
                toReturn.append(dict(zip(columns, record)))
            obsEndTime = time.perf_counter()
            print(f"Observations queried and processed in: {obsEndTime - obsStartTime:0.4f} seconds")  
            for record in toReturn:
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
    return jsonify(toReturn)

@app.route("/get_datatable_observations")
def get_datatable_observations():
    draw = 0
    start = 0
    length = 0
    search = []
    order = []
    columns = []
    index = 0
    while True:
        if(request.args.get("columns[" + str(index) + "][data]")):
            columns.append(
                {
                    "data": request.args.get("columns[" + str(index) + "][data]"),
                    "name": request.args.get("columns[" + str(index) + "][name]"),
                    "searchable": request.args.get("columns[" + str(index) + "][searchable]"),
                    "orderable": request.args.get("columns[" + str(index) + "][orderable]"),
                    "search": {
                        "value": request.args.get("columns[" + str(index) + "][search][value]"),
                        "regex": request.args.get("columns[" + str(index) + "][search][regex]")
                    }  
                }
            )
            index += 1
        else:
            break
    
    search = {
        "value": request.args.get("search[value]"),
        "regex": request.args.get("search[regex]")
    }

    if(request.args.get("draw")):
        draw = int(request.args.get("draw"))
    if(request.args.get("start")):
        start = int(request.args.get("start"))
    if(request.args.get("length")):
        length = int(request.args.get("length"))
    
    print("draw: " + str(draw))
    print("start: " + str(start))
    print("length: " + str(length))
    print("search: " + str(search))
    print("columns: " + str(columns))
    
    toReturn={
        "draw":draw
    }
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            countStartTime = time.perf_counter()
            SQL = open(QUERIES_FOLDER + "get_obs_table_count.sql", "r").read() 
            cur.execute(SQL)
            for record in cur.fetchall():
                toReturn["recordsTotal"] = record[0]
            SQL = open(QUERIES_FOLDER + "get_obs_table_count_filtered.sql", "r").read()
            cur.execute(SQL)
            for record in cur.fetchall():
                toReturn["recordsFiltered"] = record[0] 
            obsStartTime = time.perf_counter()
            SQL = open(QUERIES_FOLDER + "get_obs_table.sql", "r").read() 
            data = (length, start, )
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            obs_data = []
            for record in cur.fetchall():
                obs_data.append(dict(zip(columns, record)))
            obsEndTime = time.perf_counter()
            print(f"Observations queried and processed in: {obsEndTime - obsStartTime:0.4f} seconds")  
            for record in obs_data:
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
            toReturn["data"] = obs_data
        conn.close()
    return jsonify(toReturn)

#Test Data Endpoints
@app.route("/get_test_data")
def get_test_data():
    print("getting test data")
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_test_data.sql", "r").read() 
            cur.execute(SQL)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
        conn.close()      
    return jsonify(toReturn)

@app.route("/get_all_states_test_data")
def get_all_states_test_data():
    print("getting test data for all states")
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_all_states_test_data.sql", "r").read() 
            cur.execute(SQL)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
        conn.close()      
    return jsonify(toReturn)

#Utilities
def convert_to_parquet(query, conn, name):
    dataframe = pd.read_sql(query, conn)
    df_parquet = dataframe.to_parquet()
    return df_parquet

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)