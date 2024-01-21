FROM maven:3.9-eclipse-temurin-21-jammy AS build

ARG POSTGRESQL_HOST
ARG POSTGRESQL_USERNAME
ARG POSTGRESQL_PASSWORD
ARG POSTGRESQL_DATABASE
ARG POSTGRESQL_POSTGRES_PASSWORD

ENV POSTGRESQL_HOST ${POSTGRESQL_HOST}
ENV POSTGRESQL_USERNAME ${POSTGRESQL_USERNAME}
ENV POSTGRESQL_PASSWORD ${POSTGRESQL_PASSWORD}
ENV POSTGRESQL_DATABASE ${POSTGRESQL_DATABASE}
ENV POSTGRESQL_POSTGRES_PASSWORD ${POSTGRESQL_POSTGRES_PASSWORD}

WORKDIR /app
COPY . /app

RUN mvn clean install


FROM eclipse-temurin:21-jammy

LABEL Name=backend Version=0.0.1
WORKDIR /app
COPY --from=build /app/target/*-SNAPSHOT-jar-with-dependencies.jar /app/app.jar
COPY wait-for.sh /wait-for.sh
RUN chmod +x /wait-for.sh
RUN apt-get update && apt-get install -y postgresql-client
EXPOSE 7000
CMD ["/wait-for.sh", "postgresql", "java", "-jar", "/app/app.jar"]