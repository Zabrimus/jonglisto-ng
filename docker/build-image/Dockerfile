FROM openjdk:8-jdk-slim

WORKDIR /tmp

RUN apt-get update -qq && \
    apt-get -y install git && \

    cd /tmp && \
    git clone https://github.com/Zabrimus/jonglisto-ng.git && \
    cd jonglisto-ng && \
    chmod +x ./gradlew && \
    ./gradlew war && \
    ./gradlew copySamples

