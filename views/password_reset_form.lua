---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h2("Reset Your Password")
  form({
    action = self:url_for("password_reset"),
    method = "post",
    ["hx-push-url"] = "false",
    ["hx-indicator"] = "#loading",
    ["x-data"] = "{ viewable: false }",
    class = "grid gap-xs",
  }, function()
    label({
      ["for"] = "new-password",
    }, "New Password")
    input({
      [":type"] = "viewable ? 'text' : 'password'",
      id = "new-password",
      name = "new_password",
      class = "input",
    })
    label({
      ["for"] = "confirm-password",
    }, "Confirm Password")
    input({
      [":type"] = "viewable ? 'text' : 'password'",
      id = "confirm-password",
      name = "confirm_password",
      class = "input",
    })
    div({
      class = "show-password",
    }, function()
      label({
        ["for"] = "show-password",
      }, "Show password:")
      input({ type = "checkbox", autocomplete = "off", ["@click"] = "viewable = !viewable" })
    end)
    button({ class = "input" }, "Chnage Password")
  end)
end)
