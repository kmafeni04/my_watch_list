---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h1("404")
  h3("This page does not exist")
  a({ href = self:url_for("index") }, "Back to the home page?")
end)
