local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  div({ class = "forgot_password grid-center gap-s" }, function()
    h2("Forgotten your password?")
    p("Type in your email and we'll help you sort that out")
    if next(self.errors) then
      ul(function()
        for _, error in pairs(self.errors) do
          li({ style = "color: red" }, error)
        end
      end)
    end
    form({
      action = self:url_for("forgot_password"),
      method = "post",
      class = "grid gap-xs",
      ["hx-indicator"] = "#loading",
    }, function()
      widget(self.csrf)
      label({ ["for"] = "email" }, "Email:")
      input({
        type = "email",
        id = "email",
        name = "email",
        class = "input",
        required = true,
      })
      button({ class = "input btn" }, "Reset Password")
    end)
    p({ class = "flex gap-xs" }, function()
      text("Don't have an account?")
      a({ href = self:url_for("signup") }, "Sign up")
    end)
  end)
end)
