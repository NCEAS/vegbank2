from flask import Flask, jsonify, request, send_file
import psycopg
from psycopg import connect, ClientCursor
import pandas as pd
import pyarrow 
import io

UPLOAD_FOLDER = '/vegbank2/uploads' #For future use with uploading parquet files if necessary
ALLOWED_EXTENSIONS = 'parquet'
QUERIES_FOLDER = 'queries/'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

params = {
        'dbname' : 'vegbank',
        'user' : 'vegbank',
        'password' : 'vegbank', #TODO: set up secret for db password. This is not the real one. 
        'host' : 'vegbankdb-postgresql', #service name via bitnami postgres
        'port' : '5432'
    }

@app.route("/")
def welcome_page():
    print("hitting welcome message")
    return "<h1>Welcome to the VegBank API</h1>"


@app.route("/plot-observations", defaults={'accessioncode': None}, methods=['GET', 'POST'])
@app.route("/plot-observations/<accessioncode>")
def get_observation(accessioncode):
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            if(accessioncode == None):
                with conn.cursor() as cur:
                    SQL = "SELECT * FROM observation INNER JOIN plot ON plot.plot_id = observation.plot_id;"
                    cur.execute(SQL)
                    columns = [desc[0] for desc in cur.description]
                    for record in cur.fetchall():
                        toReturn.append(dict(zip(columns, record)))
                conn.close()   
            else:
                with conn.cursor() as cur:
                    plot_observations = []
                    SQL1 = "SELECT * FROM observation INNER JOIN plot ON plot.plot_id = observation.plot_id where observation.accessionCode = %s;"
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
                SQL = "SELECT * from plot;"
                cur.execute(SQL)
                columns = [desc[0] for desc in cur.description]
                for record in cur.fetchall():
                    toReturn.append(dict(zip(columns, record)))
            conn.close()   
        else:
            with conn.cursor() as cur:
                SQL = "SELECT * from plot where accessionCode = %s;"
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

@app.route("/get_observation_table", defaults={'pagesize': None, 'previd': None}, methods=['GET'])
@app.route("/get_observation_table/<pagesize>", defaults={'previd': None}, methods=['GET'])
@app.route("/get_observation_table/<pagesize>/<previd>")
def get_observation_table(pagesize, previd):
    toReturn = []
    if(pagesize == None):
        pagesize = 100
    if(previd == None):
        previd = 0
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = open(QUERIES_FOLDER + "get_obs_table.sql", "r").read() 
            data = (previd, pagesize, )
            print(cur.mogrify(SQL, data))
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
            for record in toReturn:
                print("record: " + str(record['plot_id']))
                SQL = open(QUERIES_FOLDER + "get_top_5_taxa_coverage.sql", "r").read()
                data = (record['plot_id'], )
                cur.execute(SQL, data)
                columns = [desc[0] for desc in cur.description]
                taxa = []
                for taxaRecord in cur.fetchall():
                    taxa.append(dict(zip(columns, taxaRecord)))
                record.update({"taxa": taxa})
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