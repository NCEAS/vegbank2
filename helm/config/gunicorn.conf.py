import os

workers = os.getenv('GUNICORN_WORKERS', default={{ .Values.gunicorn.workers }})

timeout = os.getenv('GUNICORN_TIMEOUT', default={{ .Values.gunicorn.timeout }})

bind = os.getenv('GUNICORN_PORT', default="0.0.0.0:{{ .Values.service.port }}")

accesslog = os.getenv('GUNICORN_ACCESSLOG', default='-') # Access Log to stdout
errorlog = os.getenv('GUNICORN_ERRORLOG', default='-') # Error Log to stdout
loglevel = os.getenv('GUNICORN_LOGLEVEL', default='{{ .Values.gunicorn.logLevel }}')
