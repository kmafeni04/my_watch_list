---@type Config
local config = require("lapis.config")
local dotenv = require("misc.dotenv")
local env, err = dotenv.load()

config({ "development", "production" }, {
  server = "nginx",
})

config("development", {
  code_cache = "off",
  num_workers = "1",
  port = 8080,
  sqlite = {
    database = env.get("DATABASE"),
  },
})

config("production", {
  code_cache = "on",
  num_workers = "auto",
  port = 8080,
  postgres = {
    host = env.get("PGHOST"),
    database = env.get("PGDATABASE"),
    password = env.get("PGPASSWORD"),
    port = env.get("PGPORT"),
    user = env.get("PGUSER")
  }
})
