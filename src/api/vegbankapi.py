from flask import Flask
from flask import jsonify
import psycopg
from psycopg import connect, ClientCursor

app = Flask(__name__)

@app.route("/")
def welcome_page():
    return "<h1>Welcome to the VegBank API</h1>"


@app.route("/plot/<accessioncode>")
def get_plots(accessioncode):
    toReturn = []
    params = {
        'dbname' : 'vegbank',
        'user' : 'vegbank'
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
    app.run(debug=True)