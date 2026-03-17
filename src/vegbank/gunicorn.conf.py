import os

workers = os.getenv('GUNICORN_WORKERS', default=5)

timeout = os.getenv('GUNICORN_TIMEOUT', default=1200)

bind = "0.0.0.0:8000"

accesslog = '-'
errorlog = '-'
loglevel = 'debug'
