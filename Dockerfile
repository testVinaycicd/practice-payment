# syntax=docker/dockerfile:1.7
FROM python:3.12-slim AS base

# ---- Security hardening & system deps (minimal) ----
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_HOME=/app \
    APP_PORT=8084

# Install build deps only if needed by your wheels; remove if pure-python
RUN apt-get update && apt-get install -y --no-install-recommends \
      gcc \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -r -u 10001 -g users appuser

WORKDIR ${APP_HOME}

# Copy only requirements first for better layer caching
COPY requirements.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

# Copy application code (only what you need at runtime)
# If you have extra files you don't want, add .dockerignore
COPY payment.py rabbitmq.py payment.ini ./

# Drop privileges
USER 10001


EXPOSE ${APP_PORT}

ENTRYPOINT  ["uwsgi","--ini","payment.ini"]

