local Widget = require("lapis.html").Widget

local ShowInfo = require("views.widgets.show_info")
local Comments = require("views.widgets.comments")

return Widget:extend(function(self)
	widget(ShowInfo({ show = self.show, reroute_url = self.req.parsed_url.path }))
	h2("Comments")
	if self.session.current_user then
		form({
			action = self:url_for("comments"),
			method = "post",
			["hx-confirm"] = "Are you sure you would like to make this comment?",
			["hx-target"] = "#comments",
			["hx-indicator"] = "#commenting",
			["hx-push-url"] = "false",
			class = "comments__form grid gap-s",
		}, function()
			widget(self.csrf)
			textarea({
				name = "content",
				id = "content",
				class = "input",
				autocomplete = "off",
				required = true,
			})
			input({ type = "hidden", name = "show_id", value = self.show.id })
			button({ class = "input btn" }, "Comment")
		end)
	end
	widget(Comments({ comments = self.comments }))
end)
