FROM pgrouting-localdev-base:latest

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV PGROUTING_VERSION 3.1.3
ENV PGROUTING_SHA256 54b58e8c4ac997d130e894f6311a28238258b224bb824b83f5bfa0fb4ee79c60

WORKDIR /usr/src/pgrouting

COPY . .

RUN mkdir -p build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd / \
 && apt-mark manual postgresql-12 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libcgal-dev \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/10_postgis.sh
