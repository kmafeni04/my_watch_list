---@diagnostic disable:lowercase-global
package = "my-watch-list"
version = "dev-1"

source = {
  url = "",
}

description = {
  summary = "Lapis Application",
  homepage = "",
  license = "",
}

dependencies = {
  "lua == 5.1",
  "lapis == 1.16.0",
  "etlua == 1.3.0-1",
  "lsqlite3 == 0.9.6-1",
  "bcrypt == 2.3-1",
  "lua-resty-mail == 1.1.0-1",
  "tableshape == 2.6.0-1",
}

build = {
  type = "none",
}
