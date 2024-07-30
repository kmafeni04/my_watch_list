local http = require("lapis.nginx.http")
local util = require("lapis.util")

---@async
---@param url string
---@param query? string | table
---@return table
local function json_handler(url, query)
  if query then
    if type(query) == "string" then
      local body, _, _ = http.simple(url .. query)
      local response = util.from_json(body)
      return response
    elseif type(query) == "table" then
      local query_combined = "?"
      for key, value in pairs(query) do
        query_combined = query_combined .. key .. "=" .. value .. "&"
      end
      local body, _, _ = http.simple(url .. query_combined)

      local response = util.from_json(body)
      return response
    end
  else
    local body, _, _ = http.simple(url)
    local response = util.from_json(body)
    return response
  end
end


return json_handler
