FROM python:3.13

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
LABEL org.opencontainers.image.version="0.0.3-develop"

WORKDIR /python-docker

ADD /vegbank/vegbankapi.py .
ADD /vegbank/utilities.py .
ADD queries ./queries
ADD /vegbank/operators ./operators

RUN pip install flask
RUN pip install psycopg
RUN pip install pandas
RUN pip install pyarrow

CMD [ "flask", "--app",  "vegbankapi.py", "run", "--host=0.0.0.0", "--port=80"]