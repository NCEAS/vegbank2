FROM python:3

LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"

# Install Flyway OS Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates unzip openjdk-21-jdk-headless \
 && rm -rf /var/lib/apt/lists/*

# Install Flyway CLI
ARG FLYWAY_VERSION=10.17.0
RUN curl -L -o /tmp/flyway.tar.gz \
      "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" \
 && mkdir -p /opt \
 && tar -xzf /tmp/flyway.tar.gz -C /opt \
 && ln -s /opt/flyway-${FLYWAY_VERSION} /opt/flyway \
 && rm /tmp/flyway.tar.gz
ENV PATH="/opt/flyway:${PATH}"

WORKDIR /python-docker

ADD /vegbank/vegbankapi.py .
ADD /vegbank/config.py .
ADD queries ./queries

# Add flyway migration files into this image
COPY /src/database/migrations /opt/local/flyway/db/migrations

RUN pip install flask
RUN pip install psycopg
RUN pip install pandas
RUN pip install pyarrow

CMD [ "flask", "--app",  "vegbankapi.py", "run", "--host=0.0.0.0", "--port=80"]