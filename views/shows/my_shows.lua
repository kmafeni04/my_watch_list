local Widget = require("lapis.html").Widget

local ShowInfo = require("views.widgets.show_info")

return Widget:extend(function(self)
  div({ class = "show-list flex-col-center gap-s" }, function()
    h1("My Show List")
    if type(self.shows) == "table" then
      if #self.shows ~= 0 then
        form({ action = self:url_for("shows"), method = "get", class = "flex-center flex-wrap gap-s" }, function()
          label({ class = "flex align-center gap-xs" }, function()
            text("Sort:")
            element("select", { id = "sort", name = "sort", class = "input" }, function()
              option({ value = "nil" }, "")
              option({ value = "newest" }, "Newest")
              option({ value = "oldest" }, "Oldest")
              option({ value = "watched" }, "Watched")
              option({ value = "not_watched" }, "Not Watched")
              option({ value = "a_z" }, "A - Z")
              option({ value = "z_a" }, "Z - A")
            end)
          end)
          button({ class = "input btn" }, "Submit")
        end)
        div({ class = "shows flex-col-center gap-m" }, function()
          for key, _ in pairs(self.shows) do
            local show = self.shows[key]
            widget(ShowInfo({
              show = show,
              reroute_url = self.req.parsed_url.path,
              my_show = true,
            }))
          end
        end)
      else
        h2("No shows in your list")
        a({ href = self:url_for("search"), ["hx-indicator"] = "#loading" }, "Search and add some")
      end
    end
  end)
end)
