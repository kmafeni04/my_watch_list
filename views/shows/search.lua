local Widget = require("lapis.html").Widget

local ShowInfo = require("views.widgets.show_info")

return Widget:extend(function(self)
	h1("Search List")
	if self.params.query == "" then
		form({
			class = "flex-center gap-xs",
			["hx-get"] = self:url_for("search"),
			["hx-indicator"] = "#loading",
			["hx-push-url"] = "true",
			["hx-target"] = "body",
		}, function()
			label({ ["for"] = "search" }, "Search:")
			input({ class = "input", id = "search", name = "query" })
			button({
				class = "btn input",
			}, "search")
		end)
	end
	if type(self.shows) == "table" then
		if #self.shows ~= 0 then
			div({
				class = "shows flex-col-center gap-m",
			}, function()
				for key, _ in pairs(self.shows) do
					local show = self.shows[key].show
					widget(ShowInfo({
						show = show,
						reroute_url = self.req.parsed_url.path .. "?" .. self.req.parsed_url.query,
					}))
				end
			end)
		elseif self.params.query == "" then
			h4("Search Something")
		else
			h4("Nothing found")
		end
	else
		h4("Network Issues")
		p("Refresh the page")
	end
end)
