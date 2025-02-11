from flask import Flask
from flask import jsonify
import psycopg
from psycopg import connect, ClientCursor

app = Flask(__name__)

params = {
        'dbname' : 'vegbank',
        'user' : 'vegbank',
        'password' : 'PASS', #TODO: set up secret for db password. This is not the real one. 
        'host' : 'vegbankdb-postgresql', #service name via bitnami postgres
        'port' : '5432'
    }

@app.route("/")
def welcome_page():
    print("hitting welcome message")
    return "<h1>Welcome to the VegBank API</h1>"

@app.route("/plot/<accessioncode>")
def get_plot(accessioncode):
    print("getting plot")
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = "SELECT * FROM plot INNER JOIN observation ON plot.plot_id = observation.plot_id where plot.accessionCode = %s;"
            data = (accessioncode, )
            print("Querying: " + cur.mogrify(SQL, data))
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
        conn.close()
    return jsonify(toReturn)


@app.route("/observation/<accessioncode>")
def get_observation(accessioncode):
    print("getting observation")
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = "SELECT * FROM observation INNER JOIN plot ON plot.plot_id = observation.plot_id where observation.accessionCode = %s;"
            data = (accessioncode, )
            print("Querying: " + cur.mogrify(SQL, data))
            cur.execute(SQL, data)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
                print(record)
        conn.close()
    return jsonify(toReturn)

@app.route("/allplots")
def get_all_plots():
    print("getting all plots")
    toReturn = []
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = "SELECT * from plot;"
            cur.execute(SQL)
            columns = [desc[0] for desc in cur.description]
            for record in cur.fetchall():
                toReturn.append(dict(zip(columns, record)))
        conn.close()    
    return jsonify(toReturn)



if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)