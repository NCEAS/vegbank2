import os

workers = os.getenv('GUNICORN_WORKERS', default={{ .Values.gunicorn.workers }})

timeout = os.getenv('GUNICORN_TIMEOUT', default={{ .Values.gunicorn.timeout }})

bind = os.getenv('GUNICORN_PORT', default="0.0.0.0:{{ .Values.service.port }}")

limit_request_field_size = os.getenv('GUNICORN_LIMIT_REQUEST_FIELD_SIZE', default={{ .Values.gunicorn.limitRequestFieldSize }})

accesslog = os.getenv('GUNICORN_ACCESSLOG', default='-') # Access Log to stdout
errorlog = os.getenv('GUNICORN_ERRORLOG', default='-') # Error Log to stdout
{{- $validLogLevels := tuple "debug" "info" "warning" "error" "critical" }}
{{- if not (has .Values.gunicorn.logLevel $validLogLevels) }}
{{- required ( printf ".Values.gunicorn.logLevel must be one of %s" $validLogLevels ) "" | fail }}
{{- end }}
loglevel = os.getenv('GUNICORN_LOGLEVEL', default='{{ .Values.gunicorn.logLevel }}')
