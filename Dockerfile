# syntax=docker/dockerfile:1.7
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_HOME=/app \
    APP_PORT=8084

RUN useradd -r -u 10001 -g users appuser
WORKDIR ${APP_HOME}

COPY requirements.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

COPY payment.py rabbitmq.py payment.ini ./

USER 10001
EXPOSE ${APP_PORT}

# Flask-style app object in payment.py -> app
CMD ["gunicorn", "-w", "2", "-k", "gthread", "-b", "0.0.0.0:8084", "payment:app"]

# If FastAPI instead:
# CMD ["uvicorn", "payment:app", "--host", "0.0.0.0", "--port", "8085"]


