FROM openresty/openresty:jammy

WORKDIR /app

ARG PGHOST
ARG PGPORT
ARG PGUSER
ARG PGDATABASE
ARG PGPASSWORD

ARG GMAIL_EMAIL
ARG GMAIL_PASSWORD

RUN apt-get update
RUN apt-get install -y sqlite3 \
 libssl-dev \
 libsqlite3-dev
RUN apt-get clean

RUN luarocks install luasec
RUN luarocks install lapis 
RUN luarocks install etlua 
RUN luarocks install lsqlite3
RUN luarocks install bcrypt
RUN luarocks install lua-resty-mail
RUN luarocks install tableshape

COPY . .

RUN lapis migrate production --trace

EXPOSE 433

CMD ["lapis", "server", "production"]



