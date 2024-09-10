---@type Widget
local Widget = require("lapis.html").Widget
local util = require("lapis.util")

return Widget:extend(function(self)
  raw("<!DOCTYPE html >")
  html({ lang = "en", ["hx-indicator"] = "none" }, function()
    head(function()
      meta({ charset = "UTF-8" })
      meta({ name = "viewport", content = "width=device-width, initial-scale=1" })
      meta({ ["http-equiv"] = "Content-Security-Policy", content = "upgrade-insecure-requests" })
      title(self.page_title or "My Watch List")
      link({ rel = "icon", href = "/static/favicon.ico" })
      link({ rel = "stylesheet", href = "/static/css/reset.css" })
      link({ rel = "stylesheet", href = "/static/css/utility.css" })
      link({ rel = "stylesheet", href = "/static/css/index.css" })
      link({ rel = "stylesheet", href = "/static/css/landing.css" })
      link({ rel = "stylesheet", href = "/static/css/shows.css" })
      link({ rel = "stylesheet", href = "/static/css/comments.css" })
      link({ rel = "stylesheet", href = "https://www.nerdfonts.com/assets/css/webfont.css" })
      script({ src = "/static/js/htmx(1.9.12).js" })
      script({ src = "/static/js/hyperscript.min(0.9.12).js" })
    end)
    body({ ["hx-boost"] = "true", class = "flex-col-center height-max" }, function()
      nav({ class = "top-nav fixed width-max flex gap-s" }, function()
        div({ class = "top-nav__item flex justify-start width-100" }, function()
          a({ href = self:url_for("index"), ["hx-indicator"] = "#loading" }, function()
            h2("My Watch List")
          end)
        end)
        div({ class = "top-nav__item flex-center gap-s width-100" }, function()
          form({
            action = self:url_for("search"),
            method = "GET",
            ["hx-target"] = "body",
            ["hx-push-url"] = "true",
            ["hx-indicator"] = "#loading",
            class = "search-form flex-center gap-xs",
          }, function()
            label({ ["for"] = "search-input" }, "Search:")
            if self.params.query then
              input({
                id = "search-input",
                value = util.unescape(self.params.query),
                class = "input",
                type = "search",
                name = "query",
                required = true,
                placeholder = "Search",
              })
            else
              input({
                id = "search-input",
                class = "input",
                type = "search",
                name = "query",
                required = true,
                placeholder = "Search",
              })
            end
          end)
          a({ href = self:url_for("airing"), ["hx-indicator"] = "#loading" }, "Airing")
          if self.session.current_user then
            a({ href = self:url_for("shows"), ["hx-indicator"] = "#loading" }, "My List")
            a({ href = self:url_for("settings"), ["hx-indicator"] = "#loading" }, "Settings")
          end
        end)
        div({ class = "top-nav__item flex justify-end width-100" }, function()
          if self.session.current_user then
            button({
              ["hx-post"] = self:url_for("logout"),
              ["hx-target"] = "body",
              ["hx-push-url"] = "true",
              ["hx-indicator"] = "#loading",
              ["hx-confirm"] = "Are you sure you would like to log out?",
              class = "input btn",
            }, "Logout")
          else
            a({
              href = self:url_for("login"),
              ["hx-indicator"] = "#loading",
              class = "input btn no-decoration",
            }, "Login")
          end
        end)
      end)
      div({ class = "htmx-indicator loading loading__desktop", id = "loading" })
      main({ class = "main-content flex-col-center gap-xs padding-block-l width-100" }, function()
        self:content_for("inner")
      end)
    end)
    nav({ class = "bottom-nav fixed width-max flex align-center justify-space-between gap-xs" }, function()
      a({
        href = self:url_for("index"),
        ["hx-indicator"] = "#loading",
        title = "Home",
      }, function()
        i({ class = "nf nf-fa-home" })
      end)
      a({
        href = self:url_for("search"),
        ["hx-indicator"] = "#loading",
        title = "Search",
      }, function()
        i({ class = "nf nf-fa-magnifying_glass" })
      end)
      a({
        href = self:url_for("airing"),
        ["hx-indicator"] = "#loading",
        title = "Airing",
      }, function()
        i({ class = "nf nf-md-television_play" })
      end)
      if self.session.current_user then
        a({ href = self:url_for("shows"), ["hx-indicator"] = "#loading", title = "My List" }, function()
          i({ class = "nf nf-fa-list" })
        end)
        a({ href = self:url_for("settings"), ["hx-indicator"] = "#loading", title = "Settings" }, function()
          i({ class = "nf nf-fa-gear" })
        end)
        a({
          href = "",
          title = "Logout",
          ["hx-post"] = self:url_for("logout"),
          ["hx-target"] = "body",
          ["hx-push-url"] = "true",
          ["hx-indicator"] = "#loading",
          ["hx-confirm"] = "Are you sure you would like to log out?",
        }, function()
          i({ class = "nf nf-md-logout" })
        end)
      else
        a({
          href = self:url_for("login"),
          ["hx-indicator"] = "#loading",
          title = "Login",
        }, function()
          i({ class = "nf nf-md-login" })
        end)
        a({
          href = self:url_for("signup"),
          ["hx-indicator"] = "#loading",
          title = "Sign Up",
        }, function()
          i({ class = "nf nf-fa-user_plus" })
        end)
      end
      div({ class = "htmx-indicator loading loading__mobile", id = "loading" })
    end)
  end)
end)
