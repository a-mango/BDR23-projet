# Stage 1: Run the create_seed script
FROM ubuntu as builder

WORKDIR /app
COPY ./create_seed.sh /app
COPY ./scripts /app/scripts
RUN bash /app/create_seed.sh

# Stage 2: Setup the PostgreSQL database
FROM bitnami/postgresql:16

LABEL Name=database Version=0.0.1
COPY --from=builder /app/seed.sql /docker-entrypoint-initdb.d/

ENV POSTGRESQL_LOG_STATEMENTS=all