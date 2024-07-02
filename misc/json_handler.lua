-- local httpc = require("resty.http").new()
local http = require("socket.http")
local util = require("lapis.util")
local function json_handler(url, query)
  -- local res, err = httpc:request_uri(url, {
  --   method = "GET",
  --   query = {
  --     q = query
  --   },
  --   ssl_verify = false,
  -- })

  -- if not res then
  --   ngx.log(ngx.ERR, "request failed: ", err)
  --   return
  -- end

  -- local body = res.body
  -- local to_table = util.from_json(body)
  -- return to_table
  local body, _ = http.request(url .. query)
  local response = util.from_json(body)
  return response
end

return json_handler
