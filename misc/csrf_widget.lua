--- Creates a hidden input containing the csrf token
---@param self AppSelf
local function csrf_widget(self)
  ---@type Widget
  local Widget = require("lapis.html").Widget
  local csrf = require("lapis.csrf")
  local csrf_token = csrf.generate_token(self)
  self.csrf = Widget:extend(function()
    input({ type = "hidden", value = csrf_token, name = "csrf_token" })
  end)
end

return csrf_widget
