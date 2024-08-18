local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	h1("Sign up")
	if #self.errors > 0 then
		for _, error in pairs(self.errors) do
			p(error)
		end
	end
	form({
		class = "user-form grid gap-xs",
		action = self:url_for("signup"),
		method = "post",
		["hx-indicator"] = "#loading",
		["x-data"] = "{ viewable: false }",
	}, function()
		widget(self.csrf)
		label({ ["for"] = "username" }, "Username:")
		input({
			class = "input",
			id = "username",
			type = "text",
			name = "username",
			minlength = "5",
			maxlength = "15",
		})
		label({ ["for"] = "email" }, "Email:")
		input({
			class = "input",
			id = "email",
			type = "email",
			name = "email",
		})
		label({ ["for"] = "password" }, "Password:")
		input({
			class = "input",
			id = "password",
			[":type"] = [[!viewable ? 'password' : 'text']],
			name = "password",
			minlength = "10",
			maxlength = "30",
		})
		label({ ["for"] = "confirm_password" }, "Confirm password:")
		input({
			class = "input",
			id = "confirm_password",
			[":type"] = [[!viewable ? 'password' : 'text']],
			name = "confirm_password",
			minlength = "10",
			maxlength = "30",
		})
		div({ class = "show-password" }, function()
			label({ ["for"] = "show-password" }, "Show password:")
			input({ type = "checkbox", autocomplete = "off", ["@click"] = "viewable = !viewable" })
		end)
		button({
			class = "input btn",
		}, "Sign up")
		p(function()
			text("Already have an account?")
			a({ href = self:url_for("login"), ["hx-indicator"] = "#loading" }, "Login")
		end)
	end)
end)
