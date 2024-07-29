---@type Widget
local Widget = require("lapis.html").Widget
local encrypt = require("misc.bcrypt").encrypt

return Widget:extend(nil, function(self)
  div({ class = "grid gap-s" }, function()
    h1(nil, "We've sent a code to your email")
    p(nil, "Input the code into the form below to complete your registration")
    form(
      {
        action = self:url_for("signup_complete"),
        method = "POST",
        ["hx-push-url"] = false,
        class =
        "flex-center gap-xs"
      },
      function()
        label({ ["for"] = "signup-code" }, "Code:")
        input({ type = "number", id = "signup-code", name = "signup_code", maxlength = 4, minlength = 4, class = "input" })
        input({ type = "hidden", value = self.params.username, name = "username" })
        input({ type = "hidden", value = self.params.email, name = "email" })
        input({ type = "hidden", value = encrypt(self.params.password), name = "password" })
        button({ class = "input btn" }, "Submit")
      end)
  end)
end)
