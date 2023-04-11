FROM gcc

RUN apt-get update
RUN apt-get install -y mandoc git zip unzip curl wget

RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

WORKDIR /opt/source
