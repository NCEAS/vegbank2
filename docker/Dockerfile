FROM python:3

LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"

WORKDIR /python-docker

ADD /vegbank/vegbankapi.py .
ADD /vegbank/config.py .
ADD queries ./queries

# Add flyway migration files into this image
COPY /vegbank/src/database/migrations /opt/local/flyway/migrations

RUN pip install flask
RUN pip install psycopg
RUN pip install pandas
RUN pip install pyarrow

CMD [ "flask", "--app",  "vegbankapi.py", "run", "--host=0.0.0.0", "--port=80"]