FROM python:3.13

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
LABEL org.opencontainers.image.version="0.0.3-303-docker-venv"

# Add Docker VENV path
ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"
# Do not create __pycache__/ directories
ENV PYTHONDONTWRITEBYTECODE=1
# Ensure logs behave correctly by flushing out stdout/stderr immediately
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create VENV and upgrade pip toools
RUN python -m venv "$VENV_PATH" && pip install --upgrade pip setuptools wheel

# Install runtime dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# TODO: We should be able to simply copy the application code instead of two directories
# Ex. COPY . /app
COPY vegbank /app/vegbank
COPY queries /app/queries

ENV PYTHONPATH=/app
CMD [ "flask", "--app",  "vegbank.vegbankapi:app", "run", "--host=0.0.0.0", "--port=80"]