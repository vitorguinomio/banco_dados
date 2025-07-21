FROM python:3.11-slim

ENV POSTGRES_USER=vitor
ENV POSTGRES_PASSWORD=133122
ENV POSTGRES_DB=peso

# Instala PostgreSQL e dependências
RUN apt-get update && apt-get install -y \
    postgresql postgresql-contrib libpq-dev gcc python3-dev \
    && pip install --no-cache-dir psycopg2-binary \
    && apt-get clean

RUN mkdir -p /var/lib/postgresql/data

WORKDIR /app

COPY . .

# Comando de inicialização
CMD bash -c "\
    service postgresql start && \
    sudo -u postgres psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\" && \
    sudo -u postgres psql -c \"CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;\" && \
    python3 entrada.py"

ENTRYPOINT []
CMD ["python3", "main.py"]
