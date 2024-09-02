FROM openresty/openresty:jammy

WORKDIR /app

ARG DATABASE
ARG PGDATABASE
ARG PGPORT
ARG PGUSER
ARG PGPASSWORD
ARG PGHOST

RUN apt-get update
RUN apt-get install -y sqlite3 \
 libssl-dev \
 libsqlite3-dev
RUN apt-get clean

COPY . .

RUN luarocks install --only-deps --lua-version=5.1 my-watch-list-dev-1.rockspec
RUN lapis migrate production --trace

EXPOSE 8080

CMD ["lapis", "server", "production"]



