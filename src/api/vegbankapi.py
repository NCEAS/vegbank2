from flask import Flask
from flask import jsonify
import psycopg
from psycopg import connect, ClientCursor

app = Flask(__name__)

@app.route("/")
def welcome_page():
    print("hitting welcome message")
    return "<h1>Welcome to the VegBank API</h1>"

@app.route("/plot/<accessioncode>")
def get_plots(accessioncode):
    print("getting plot")
    toReturn = []
    params = {
        'dbname' : 'vegbank',
        'user' : 'vegbank',
        'password' : 'PASS', #TODO: set up secret for db password. This is not the real one. 
        'host' : 'vegbankdb-postgresql', #service name via bitnami postgres
        'port' : '5432'
    }
    with psycopg.connect(**params, cursor_factory=ClientCursor) as conn:
        with conn.cursor() as cur:
            SQL = "SELECT plot_id, latitude, longitude, accessionCode FROM plot where accessionCode = %s;"
            data = (accessioncode, )
            print("Querying: " + cur.mogrify(SQL, data))
            cur.execute(SQL, data)
            for record in cur.fetchall():
                toReturn.append(record)
                print(record)
        conn.close()
    return jsonify(toReturn)

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=80,debug=True)