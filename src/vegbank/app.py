import os
from flask import Flask
from vegbank.vegbankapi import main
from vegbank.auth import init_oauth

def create_app():
    app = Flask(__name__)
    app.register_blueprint(main)
    app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY', os.urandom(32).hex())
    init_oauth(app)
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(port=8000)