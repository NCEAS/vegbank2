FROM python:3.13

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
LABEL org.opencontainers.image.version="0.0.3-303-docker-venv"

# Add Docker VENV path
ENV VIRTUAL_ENV=/data/venv
# Do not create __pycache__/ directories
ENV PYTHONDONTWRITEBYTECODE=1
# Ensure logs behave correctly by flushing out stdout/stderr immediately
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY pyproject.toml uv.lock* /app/

# Install uv
RUN python -m pip install uv --root-user-action ignore

# Create (or reuse) the venv at $VIRTUAL_ENV
RUN uv venv --allow-existing "${VIRTUAL_ENV}"

# Activate uv venv
RUN . "${VIRTUAL_ENV}/bin/activate" && uv sync --active

# TODO: We should be able to simply copy the application code instead of two directories
# Ex. COPY . /app
COPY vegbank /app/vegbank
COPY queries /app/queries

ENV PYTHONPATH=/app
CMD ["/data/venv/bin/python", "-m", "flask", "--app", "vegbank.vegbankapi:app", "run", "--host=0.0.0.0", "--port=80"]