local http = require("lapis.nginx.http")
local util = require("lapis.util")

---@param url string
---@param query string
---@return table
local function json_handler(url, query)
  local body, _, _ = http.simple(url .. query)

  local response = util.from_json(body)
  return response
end


return json_handler
