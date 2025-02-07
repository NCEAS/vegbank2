FROM python:3

LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"

WORKDIR /python-docker

ADD /vegbank/vegbankapi.py .

RUN pip install flask && pip install psycopg

CMD [ "flask", "--app",  "vegbankapi.py", "run", "--host=0.0.0.0", "--port=80"]