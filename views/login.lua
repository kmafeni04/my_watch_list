local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	h1("Login")
	if #self.errors > 0 then
		for _, error in pairs(self.errors) do
			p(error)
		end
	end
	form({
		class = "user-form grid gap-xs",
		action = self:url_for("login"),
		method = "post",
		["hx-indicator"] = "#loading",
		["x-data"] = "{ viewable: false }",
	}, function()
		label({ ["for"] = "username" }, "Username:")
		input({
			class = "input",
			id = "username",
			type = "text",
			name = "username",
		})
		label({ ["for"] = "password" }, "Password:")
		input({
			class = "input",
			id = "password",
			[":type"] = [[!viewable ? 'password' : 'text']],
			name = "password",
		})
		div({ class = "show-password" }, function()
			label({ ["for"] = "show-password" }, "Show password:")
			input({
				type = "checkbox",
				id = "show-password",
				autocomplete = "off",
				["@click"] = "viewable = !viewable",
			})
		end)
		a({ href = self:url_for("forgot_password") }, "Forgot Password?")
		button({ class = "input btn" }, "Login")
		p(function()
			text([[Don't have an account?]])
			a({ href = self:url_for("signup"), ["hx-indicator"] = "#loading" }, "Sign up")
		end)
	end)
end)
