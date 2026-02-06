FROM python:3.13

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
LABEL org.opencontainers.image.version="0.0.3-289-importbugs"

WORKDIR /app

COPY vegbank /app/vegbank
COPY queries /app/queries

RUN pip install flask
RUN pip install psycopg
RUN pip install pandas
RUN pip install pyarrow

ENV PYTHONPATH=/app
CMD [ "flask", "--app",  "vegbank.vegbankapi:app", "run", "--host=0.0.0.0", "--port=80"]