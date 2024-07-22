local lapis = require("lapis")
---@type App
local app = lapis.Application()
app:enable("etlua")
app.layout = require "views.layout"

local generic_controller = require("controllers.generic_controller")
local shows_controller = require("controllers.shows_controller")
local user_controller = require("controllers.user_controller")

app:before_filter(function(self)
  local protected_routes = {
    [self:url_for("index")] = true,
    [self:url_for("login")] = true,
    [self:url_for("signup")] = true,
    [self:url_for("search")] = true,
    [self:url_for("airing")] = true,
    ["/proxy"] = true,
    ["/favicon.ico"] = true,
  }
  if not self.session.current_user and not protected_routes[self.req.parsed_url.path] then
    self:write({ redirect_to = self:url_for("login") })
  end
end)

app:before_filter(function(self)
  local protected_routes = {
    [self:url_for("login")] = true,
    [self:url_for("signup")] = true,
  }
  if self.session.current_user and protected_routes[self.req.parsed_url.path] then
    self:write({ redirect_to = self:url_for("index") })
  end
end)

app:get("index", "/", generic_controller.root)

app:get("login", "/login", user_controller.login)
app:post("login", "/login", user_controller.login_post)

app:get("signup", "/signup", user_controller.signup)
app:post("signup", "/signup", user_controller.signup_post)

app:get("settings", "/settings", user_controller.settings)
app:post("settings", "/settings", user_controller.settings_general)
app:put("change_password", "/change_password", user_controller.settings_password)

app:delete("delete_account", "/delete_account", user_controller.delete_account)

app:post("logout", "/logout", user_controller.logout)

app:get("search", "/search", shows_controller.search)

app:get("shows", "/shows", shows_controller.shows)

app:post("show", "/show/:id", shows_controller.show_post)
app:delete("show", "/show/:id", shows_controller.show_delete)

app:get("airing", "/airing", shows_controller.airing)

return app
