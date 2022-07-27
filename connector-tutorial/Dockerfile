FROM python:3.9.12-slim-buster

ARG CONNECTOR_VERSION=latest
ENV CONNECTOR_VERSION=${CONNECTOR_VERSION}

COPY requirements.txt /app/requirements.txt
RUN python3 -m pip install -r /app/requirements.txt

COPY *.json *.py /app/

CMD ["python3", "/app/connector.py", "/data/input/inputFile.json", "/data/output/data.json", "/app/input-schema.json", "/app/output-schema.json"]
