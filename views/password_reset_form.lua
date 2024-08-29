---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h2("Reset Your Password")
  form({
    action = self:url_for("password_reset"),
    method = "post",
    ["hx-push-url"] = "false",
    ["hx-indicator"] = "#loading",
    class = "grid gap-xs",
  }, function()
    widget(self.csrf)
    label({
      ["for"] = "new-password",
    }, "New Password")
    input({
      id = "new-password",
      name = "new_password",
      class = "input",
    })
    label({
      ["for"] = "confirm-password",
    }, "Confirm Password")
    input({
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
      input({
        type = "checkbox",
        autocomplete = "off",
        _ = [[
            on click
            for input in [#new-password, #confirm-new-password]
              if input's @type is "password" then
                set input's @type to "text"
              else
                set input's @type to "password"
              end
            end
          ]],
      })
    end)
    button({ class = "input" }, "Chnage Password")
  end)
end)
