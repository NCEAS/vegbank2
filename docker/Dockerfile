FROM python:3

LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"

WORKDIR /python-docker

ADD /dist/vegbank-2.0.0a1-py3-none-any.whl .

RUN pip install vegbank-2.0.0a1-py3-none-any.whl

ADD /vegbank/run.py .

CMD ["python", "run.py"]