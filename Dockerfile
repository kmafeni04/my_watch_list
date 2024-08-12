FROM openresty/openresty:jammy

WORKDIR /app

ARG DATABASE

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

RUN mkdir /data

RUN lapis migrate production --trace

EXPOSE 80

CMD ["lapis", "server", "production"]



