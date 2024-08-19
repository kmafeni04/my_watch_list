local Widget = require("lapis.html").Widget

local ShowInfo = require("views.widgets.show_info")

return Widget:extend(function(self)
	div({ class = "show-list flex-col-center gap-s" }, function()
		h1("My Show List")
		if type(self.shows) == "table" then
			if #self.shows ~= 0 then
				div({ class = "shows flex-col-center gap-m" }, function()
					for key, _ in pairs(self.shows) do
						local show = self.shows[key]
						widget(ShowInfo({ show = show, reroute_url = self.req.parsed_url.path }))
					end
				end)
			else
				h2("No shows in your list")
				a({ href = self:url_for("search"), ["hx-indicator"] = "#loading" }, "Search and add some")
			end
		end
	end)
end)
