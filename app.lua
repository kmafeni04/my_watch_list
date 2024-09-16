local lapis = require("lapis")
---@type App
local app = lapis.Application()
app:enable("etlua")
app.layout = require("views.layout")

local generic_controller = require("controllers.generic_controller")
local shows_controller = require("controllers.shows_controller")
local user_controller = require("controllers.user_controller")

-- Set cookie attributes
local date = require("date")
app.cookie_attributes = function()
  local expires = date(true):adddays(14):fmt("${http}")
  return "Expires=" .. expires .. "; Path=/; HttpOnly"
end

-- Sets current user if cookie is valid
app:before_filter(function(self)
  if self.cookies.remember_me then
    self.session.current_user = self.cookies.remember_me
  end
end)

--- CSRF widget
app:before_filter(function(self)
  require("misc.csrf_widget")(self)
end)

-- User not logged in
app:before_filter(function(self)
  local protected_routes = {
    [self:url_for("settings")] = true,
    [self:url_for("shows")] = true,
  }
  if not self.session.current_user and protected_routes[self.req.parsed_url.path] then
    self:write({ redirect_to = self:url_for("login") })
  end
end)

-- User logged in
app:before_filter(function(self)
  local protected_routes = {
    [self:url_for("login")] = true,
    [self:url_for("signup")] = true,
    [self:url_for("forgot_password")] = true,
  }
  if self.session.current_user and protected_routes[self.req.parsed_url.path] then
    self:write({ redirect_to = self:url_for("index") })
  end
end)

function app:handle_404()
  return { render = "404_page", status = 404 }
end

app:get("index", "/", generic_controller.root)

app:get("login", "/login", user_controller.login)
app:post("login", "/login", user_controller.login_post)

app:get("signup", "/signup", user_controller.signup)
app:post("signup", "/signup", user_controller.signup_post)
app:post("signup_complete", "/signup_complete", user_controller.signup_complete)

app:get("forgot_password", "/forgot_password", user_controller.forgot_password)
app:post("forgot_password", "/forgot_password", user_controller.forgot_password_post)
app:post("password_reset_sent", "/password_reset_sent", user_controller.password_reset_sent)

app:post("password_reset", "/password_reset", user_controller.password_reset)

app:get("settings", "/settings", user_controller.settings)
app:post("settings", "/settings", user_controller.settings_general)
app:put("change_password", "/change_password", user_controller.settings_password)

app:delete("delete_account", "/delete_account", user_controller.delete_account)

app:post("logout", "/logout", user_controller.logout)

app:get("search", "/search", shows_controller.search)

app:get("shows", "/shows", shows_controller.shows)

app:get("show_button", "/show_button/:show_id/:reroute_url", shows_controller.show_button)

app:post("show_watched", "/show_watched/:show_id", shows_controller.show_watched)

app:get("show", "/shows/:id/:name", shows_controller.show)
app:post("show", "/shows/:id/:name", shows_controller.show_post)
app:delete("show", "/shows/:id/:name", shows_controller.show_delete)

app:post("comments", "/comments", shows_controller.comments_post)

app:delete("comment", "/comment/:id", shows_controller.comment_delete)

app:get("comment_likes_load", "/comment/:id/load", shows_controller.comment_likes_load)
app:post("comment_like", "/comment/:id/like", shows_controller.comment_like)
app:post("comment_dislike", "/comment/:id/dislike", shows_controller.comment_dislike)

app:get("airing", "/airing", shows_controller.airing)

return app
