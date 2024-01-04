FROM maven:3.9-eclipse-temurin-21-jammy

#Name the image as backend
LABEL Name=backend Version=0.0.1
WORKDIR /app
COPY . /app

RUN mvn clean install

EXPOSE 7000

ENTRYPOINT java -jar target/*-SNAPSHOT-jar-with-dependencies.jar