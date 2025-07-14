FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libpq-dev gcc postgresql postgresql-contrib \
 && pip install --upgrade pip \
 && pip install virtualenv ipython jupyterlab pandas psycopg2-binary \
 && apt-get remove -y gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 8888
EXPOSE 5432  

CMD service postgresql start && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root


