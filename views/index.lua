local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	div({ class = "landing flex-center gap-l width-max" }, function()
		div({ class = "landing__half flex-col gap-xs width-100" }, function()
			h1({ class = "landing__title" }, "My Watch List")
			p(
				{ class = "landing__paragraph" },
				"Stay on top of what you're watching! Manage your favorite shows and never lose track of your must-sees!"
			)
			if not self.session.current_user then
				button({
					class = "input btn landing__btn flex-center gap-xs",
					["hx-get"] = self:url_for("signup"),
					["hx-target"] = "body",
					["hx-indicator"] = "#loading",
					["hx-push-url"] = "true",
				}, function()
					text("Get Started")
					i({ class = "nf nf-cod-triangle_right" })
				end)
				a({ href = self:url_for("search"), ["hx-indicator"] = "#loading" }, "Want to try out the search first?")
			else
				button({
					class = "input btn landing__btn flex-center gap-xs",
					["hx-get"] = self:url_for("search"),
					["hx-target"] = "body",
					["hx-indicator"] = "#loading",
					["hx-push-url"] = "true",
				}, function()
					text("Go searching")
					i({ class = "nf nf-cod-triangle_right" })
				end)
			end
		end)
		div({ class = "landing__half width-100" }, function()
			div({ class = "landing__images flex" }, function()
				img({ src = "/static/assets/landing-image.png", class = "landing__image" })
			end)
		end)
	end)
end)
