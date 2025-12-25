FROM apache/airflow:2.10.2
USER root
RUN apt-get update && \
    apt-get install -y git build-essential libpq-dev && \
    apt-get clean
USER airflow
RUN pip install uv && uv pip install astronomer-cosmos dbt-postgres
