local Widget = require("lapis.html").Widget
local util = require("lapis.util")

return Widget:extend(function(self)
	if not self.show_id then
		form({
			["hx-post"] = self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) }),
			["hx-swap"] = "outerHTML",
			["hx-target"] = "body",
			["hx-push-url"] = "true",
			["hx-indicator"] = "next #show-indicator",
		}, function()
			widget(self.csrf)
			input({ type = "hidden", name = "reroute_url", value = self:url_for("shows") })
			button({ class = "btn input width-100" }, function()
				text("Add to List")
			end)
		end)
		p({ class = "htmx-indicator", id = "show-indicator" }, "Adding...")
	else
		form({

			["hx-delete"] = self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) }),
			["hx-swap"] = "outerHTML",
			["hx-target"] = "body",
			["hx-push-url"] = "true",
			["hx-include"] = "find input",
			["hx-indicator"] = "next #show-indicator",
		}, function()
			button({ class = "btn input width-100" }, function()
				text("Remove from List")
			end)
			widget(self.csrf)
			input({
				type = "hidden",
				name = "reroute_url",
				value = util.unescape(self.reroute_url),
			})
		end)
		p({
			class = "htmx-indicator",
			id = "show-indicator",
		}, "Removing...")
	end
end)
