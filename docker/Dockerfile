FROM python:3.13

ARG IMG_VER=''

LABEL org.opencontainers.image.title="vegbank2 Flask API"
LABEL org.opencontainers.image.source="http://github.com/nceas/vegbank2"
LABEL org.opencontainers.image.version=${IMG_VER}

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

# TODO: Delete when package is released and can be installed via pip
COPY src/vegbank /app/vegbank
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
ENV PYTHONPATH=/app
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "vegbank.gunicorn_test:app"]