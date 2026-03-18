import os

workers = os.getenv('GUNICORN_WORKERS', default=5)

timeout = os.getenv('GUNICORN_TIMEOUT', default=2400)

bind = os.getenv('GUNICORN_PORT', default="0.0.0.0:8000") 

accesslog = os.getenv('GUNICORN_ACCESSLOG', default='-') # Access Log to stdout
errorlog = os.getenv('GUNICORN_ERRORLOG', default='-') # Error Log to stdout
loglevel = os.getenv('GUNICORN_LOGLEVEL', default='debug')
