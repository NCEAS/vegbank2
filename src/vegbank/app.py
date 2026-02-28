from flask import Flask
from vegbank.vegbankapi import main

def create_app():
    app = Flask(__name__)
    app.register_blueprint(main)
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(port=8000, debug=True)