# My Watch List

A TV series watchlist used to keep track of shows you'd like to watch as well as discover new ones. [Website](https://mywatchlist.up.railway.app/)

## Built with
- Lapis
- HTMX
- Hyperscript

## How to run locally
My Watch List is built with the lapis web framework, It uses lua for the programming logic and openresty as it's backend, if you would like to run it locally, please follow these steps:

### Requirements
- lua 5.1 / luaJIT
- luarocks
- openresty

### How to run
```sh
git clone https://github.com/kmafeni04/my_watch_list
cd my_watch_list
luarocks install --only-deps --lua-version=5.1 my-watch-list-dev-1.rockspec
lapis migrate
lapis server 
```
Open your browser at <http://127.0.0.1:8080/>

## Docker
There is also a Dockerfile provided that can be used to run the project in production mode but a postgres database must be provided with environment variables matching those present in the file

### Requirements
- Docker
- Docker-buildx

### How to run
```sh
docker build -t my_watch_list \ 
--build-arg LAPIS_ENVIRONMENT="production" \
--build-arg PGDATABASE="YOUR_VAR" \
--build-arg PGPORT="YOUR_VAR" \
--build-arg PGUSER="YOUR_VAR" \
--build-arg PGPASSWORD="YOUR_VAR" \
--build-arg PGHOST="YOUR_VAR" . 
docker run -p 8080:8080 my_watch_list 
```
Open your browser at <http://127.0.0.1:8080/>
