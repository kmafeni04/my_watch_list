local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	local util = require("lapis.util")
	if not self.show_id then
		button({
			class = "btn input",
			["hx-post"] = self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) }),
			["hx-swap"] = "outerHTML",
			["hx-target"] = "body",
			["hx-push-url"] = "true",
			["hx-include"] = "find input",
			["hx-indicator"] = "next #show-indicator",
		}, function()
			text("Add to List")
			input({
				type = "hidden",
				name = "reroute_url",
				value = self:url_for("shows"),
			})
		end)
		p({
			class = "htmx-indicator",
			id = "show-indicator",
		}, "Adding...")
	else
		button({
			class = "btn input",
			["hx-delete"] = self:url_for("show", { id = self.show.id, name = util.slugify(self.show.name) }),
			["hx-swap"] = "outerHTML",
			["hx-target"] = "body",
			["hx-push-url"] = "true",
			["hx-include"] = "find input",
			["hx-indicator"] = "next #show-indicator",
		}, function()
			text("Remove from List")
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
