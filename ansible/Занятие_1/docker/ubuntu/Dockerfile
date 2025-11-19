FROM ubuntu:latest
LABEL authors="kvl"

RUN apt-get update && \
    apt-get install -y procps vim python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["top", "-b"]