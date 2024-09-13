---@type Widget
local Widget = require("lapis.html").Widget
local util = require("lapis.util")

return Widget:extend(function(self)
  div({ class = "show flex-center gap-s" }, function()
    if type(self.show.image) == "table" and type(self.show.image.original) == "string" then
      img({
        class = "show__image",
        src = self.show.image.original,
        alt = "Image for " .. self.show.name,
      })
    else
      p({ class = "show__image flex-col-center" }, "No image provided")
    end
    div({
      class = "show__info grid gap-xs",
    }, function()
      if
        self.req.parsed_url.path
        ~= self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) })
      then
        a({
          href = self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) }),
          ["hx-indicator"] = "#loading",
        }, function()
          h2(self.show.name)
        end)
      else
        h2(self.show.name)
      end
      p(function()
        text("Rating: ")
        if type(self.show.rating.average) == "number" and self.show.rating.average ~= 0 then
          text(self.show.rating.average .. "/10")
        else
          text("N/A")
        end
      end)
      p(function()
        text("Genres: ")
        if #self.show.genres ~= 0 then
          text(table.concat(self.show.genres, " | "))
        else
          text("N/A")
        end
      end)
      p(function()
        text("Language: ")
        if type(self.show.language) == "string" then
          text(self.show.language)
        else
          text("N/A")
        end
      end)
      p(function()
        text("Premiered: ")
        if type(self.show.premiered) == "string" then
          text(self.show.premiered)
        else
          text("N/A")
        end
      end)
      p(function()
        text("Status: " .. self.show.status)
      end)
      p(function()
        text("Official Site: ")
        if type(self.show.officialSite) == "string" then
          a({
            href = self.show.officialSite,
            target = "_blank",
          }, "Link")
        else
          text("N/A")
        end
      end)
      if self.my_show then
        p(self.watched)
        form({
          ["hx-post"] = self:url_for("show_watched", { show_id = self.show.id }),
          ["hx-swap"] = "innerHTML",
          ["hx-trigger"] = "click",
          ["hx-indicator"] = "#watched-indicator",
          class = "flex align-center gap-xs",
        }, function()
          local watched = false
          if self.show.watched == "true" then
            watched = true
          end
          label({ ["for"] = "watched" }, "Watched:")
          input({
            id = "watched",
            type = "checkbox",
            autocomplete = "off",
            checked = watched,
          })
          p({ id = "watched-indicator", class = "htmx-indicator" }, "Updating...")
        end)
      end
      if type(self.show.summary) == "string" then
        if
          self.req.parsed_url.path
          ~= self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) })
        then
          div({
            _ = [[
            on load 
            set desired_length to 250
            set text to my innerHTML
            if text.length > desired_length 
              set my innerHTML to text.substring(0, desired_length).trim() + '...'
            end
          ]],
          }, function()
            raw(self.show.summary)
          end)
        else
          raw(self.show.summary)
        end
      else
        text("No summary Available")
      end
      div({
        ["hx-get"] = self:url_for(
          "show_button",
          { show_id = self.show.id, reroute_url = util.escape(self.reroute_url) }
        ),
        ["hx-target"] = "this",
        ["hx-swap"] = "outerHTML",
        ["hx-trigger"] = "load",
      })
    end)
  end)
end)
