local Widget = require("lapis.html").Widget
local ShowInfo = require("views.widgets.show_info")

return Widget:extend(function(self)
	div({ class = "airing flex-col-center gap-s" }, function()
		h1("Top 5 Airing " .. self.day)
		form({
			action = self:url_for("airing"),
			["hx-indicator"] = "#loading",
			class = "flex-center flex-wrap gap-s",
		}, function()
			label({ ["for"] = "date", class = "flex-center gap-xs" }, function()
				text("Date:")
				input({
					name = "date",
					type = "date",
					id = "date",
					class = "input",
					max = os.date("%Y-%m-%d"),
					autocomplete = "off",
					value = self.time,
				})
			end)
			label({ ["for"] = "country", class = "flex-center gap-xs" }, function()
				text("Country:")
				element("select", { name = "country", id = "country", class = "input" }, function()
					option({ hidden = true, value = "US" })
					option({ value = "AF" }, "Afghanistan")
					option({ value = "AL" }, "Albania")
					option({ value = "DZ" }, "Algeria")
					option({ value = "AR" }, "Argentina")
					option({ value = "AM" }, "Armenia")
					option({ value = "GB" }, "United Kingdom")
					option({ value = "US" }, "United States")
				end)
			end)
			button({ class = "input btn" }, "Sort")
		end)
		if type(self.shows) == "table" and next(self.shows) ~= nil then
			div({ class = "popular-shows flex-col-center gap-m" }, function()
				for key in pairs(self.shows) do
					local show = self.shows[key]
					widget(ShowInfo({ show = show, reroute_url = self.req.parsed_url.path }))
				end
			end)
		else
			h2("Nothing to show")
		end
	end)
end)
