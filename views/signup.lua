---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h1("Sign up")
  if #self.errors > 0 then
    ul(function()
      for _, error in pairs(self.errors) do
        li({ style = "color: red;" }, error)
      end
    end)
  end
  form({
    class = "user-form grid gap-xs",
    action = self:url_for("signup"),
    method = "post",
    ["hx-indicator"] = "#loading",
    ["x-data"] = "{ viewable: false }",
  }, function()
    widget(self.csrf)
    label({ ["for"] = "username" }, "Username:")
    input({
      class = "input",
      id = "username",
      type = "text",
      name = "username",
      minlength = "5",
      maxlength = "15",
      required = true,
      placeholder = "Username",
      ["data-validate"] = true,
    })
    label({ ["for"] = "email" }, "Email:")
    input({
      class = "input",
      id = "email",
      type = "email",
      name = "email",
      required = true,
      placeholder = "example@email.com",
      ["data-validate"] = true,
    })
    label({ ["for"] = "password" }, "Password:")
    input({
      class = "input",
      id = "password",
      [":type"] = [[!viewable ? 'password' : 'text']],
      name = "password",
      minlength = "8",
      maxlength = "30",
      required = true,
      placeholder = "8+ characters",
      ["data-validate"] = true,
    })
    label({ ["for"] = "confirm_password" }, "Confirm password:")
    input({
      class = "input",
      id = "confirm_password",
      [":type"] = [[!viewable ? 'password' : 'text']],
      name = "confirm_password",
      minlength = "8",
      maxlength = "30",
      required = true,
      placeholder = "8+ characters",
      ["data-validate"] = true,
    })
    div({ class = "show-password flex align-center gap-xs" }, function()
      label({ ["for"] = "show-password" }, "Show password:")
      input({ type = "checkbox", autocomplete = "off", ["@click"] = "viewable = !viewable" })
    end)
    button({
      class = "input btn",
    }, "Sign up")
    p({ class = "flex gap-xs" }, function()
      text("Already have an account?")
      a({ href = self:url_for("login"), ["hx-indicator"] = "#loading" }, "Login")
    end)
  end)
end)
