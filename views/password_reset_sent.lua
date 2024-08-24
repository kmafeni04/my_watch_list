---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h2("We've sent a resend code to your email")
  p("Please input it into the form below")
  form({
    action = self:url_for("password_reset_sent"),
    method = "post",
    ["hx-push-url"] = "false",
    ["hx-indicator"] = "#loading",
    class = "grid gap-xs",
  }, function()
    label({ ["for"] = "code-input" }, "Code:")
    input({
      type = "text",
      id = "code-input",
      name = "code",
      class = "input",
    })
    button({ class = "input" }, "Submit")
  end)
end)
