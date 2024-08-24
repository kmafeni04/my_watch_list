---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  h1("Login")
  if #self.errors > 0 then
    ul(function()
      for _, error in pairs(self.errors) do
        li({ style = "color: red;" }, error)
      end
    end)
  end
  form({
    class = "user-form grid gap-xs",
    action = self:url_for("login"),
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
      placeholder = "username",
      ["data-validate"] = true,
    })
    label({ ["for"] = "password" }, "Password:")
    input({
      class = "input",
      id = "password",
      [":type"] = "!viewable ? 'password' : 'text'",
      name = "password",
      minlength = "8",
      maxlength = "30",
      required = true,
      placeholder = "8+ characters",
      ["data-validate"] = true,
    })
    div({ class = "show-password flex align-center gap-xs" }, function()
      label({ ["for"] = "show-password" }, "Show password:")
      input({
        type = "checkbox",
        id = "show-password",
        autocomplete = "off",
        ["@click"] = "viewable = !viewable",
      })
    end)
    a({ href = self:url_for("forgot_password") }, "Forgot Password?")
    button({ class = "input btn" }, "Login")
    p({ class = "flex gap-xs" }, function()
      text("Don't have an account?")
      a({ href = self:url_for("signup"), ["hx-indicator"] = "#loading" }, "Sign up")
    end)
  end)
end)
