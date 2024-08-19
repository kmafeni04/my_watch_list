---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	div({ class = "settings grid-center gap-s" }, function()
		div({ class = "settings__general grid-center gap-s" }, function()
			h2("General")
			form({
				["hx-post"] = self:url_for("settings"),
				["hx-confirm"] = "Are you sure you would like to make these changes?",
				["hx-target"] = "body",
				["hx-push-url"] = "true",
				["hx-indicator"] = "#loading",
				class = "settings-form grid gap-s",
				["x-data"] = "{ editable: false, viewable: false }",
			}, function()
				if self.general_errors and next(self.general_errors) ~= nil then
					div({
						class = "general-errors",
					}, function()
						ul(function()
							for _, error in pairs(self.general_errors) do
								li({ style = "color: red;" }, error)
							end
						end)
					end)
				end
				label({
					["for"] = "username",
				}, "Username:")
				input({
					id = "username",
					[":value"] = [[editable ? ']] .. self.user.username .. [[' : ']] .. self.user.username .. [[']],
					name = "username",
					class = "input",
					[":disabled"] = "!editable ? true : false",
					required = true,
				})
				label({
					["for"] = "email",
				}, "Email:")
				input({
					id = "email",
					[":value"] = [[editable ? ']] .. self.user.email .. [[' : ']] .. self.user.email .. [[']],
					[":disabled"] = "!editable ? true : false",
					name = "email",
					class = "input",
					required = true,
				})
				button({
					type = "button",
					["x-show"] = "!editable",
					["@click"] = "editable = true",
					class = "input btn width-100",
				}, "Edit")
				div({
					class = "settings-form__buttons flex align-center gap-s",
				}, function()
					button({
						type = "button",
						["x-show"] = "editable",
						["@click"] = "editable = false",
						class = "input btn width-100",
					}, "Cancel")
					button({
						class = "input btn width-100",
						["x-show"] = "editable",
					}, "Submit")
				end)
			end)
			button({
				["hx-delete"] = self:url_for("delete_account"),
				["hx-target"] = "body",
				["hx-push-url"] = self:url_for("index"),
				["hx-confirm"] = "Are you sure you would like to delete your account?",
				class = "input btn-danger width-100",
			}, "Delete Account")
		end)
		div({
			class = "settings__password grid justify-center gap-s",
			["x-data"] = "{ editable: false, viewable: false }",
		}, function()
			h2("Password")
			if self.password_errors and next(self.password_errors) ~= nil then
				div({
					class = "password-errors",
				}, function()
					ul(function()
						for _, error in pairs(self.password_errors) do
							li({ style = "color: red;" }, error)
						end
					end)
				end)
			end
			form({
				["hx-put"] = self:url_for("change_password"),
				["hx-target"] = "body",
				["hx-indicator"] = "#loading",
				["x-show"] = "editable",
				class = "grid gap-s",
			}, function()
				label({
					["for"] = "current-password",
				}, "Current Password:")
				input({
					[":type"] = "viewable ? 'text' : 'password'",
					name = "current_password",
					id = "current-password",
					class = "input",
					required = true,
				})
				label({
					["for"] = "new-password",
				}, "New Password:")
				input({
					[":type"] = "viewable ? 'text' : 'password'",
					name = "new_password",
					id = "new-password",
					class = "input",
					required = true,
				})
				label({
					["for"] = "confirm-new-password",
				}, "Confirm New Password:")
				input({
					[":type"] = "viewable ? 'text' : 'password'",
					name = "confirm_new_password",
					id = "confirm-new-password",
					class = "input",
					required = true,
				})
				div({ class = "show-password" }, function()
					label({ ["for"] = "show-password-check" }, "Show Password")
					input({ type = "checkbox", autocomplete = "off", ["@click"] = "viewable = !viewable" })
				end)
				div({ class = "settings-form__buttons flex align-center gap-s" }, function()
					button({
						type = "button",
						["@click"] = "editable = false",
						class = "input btn width-100",
					}, "Cancel")
					button({ class = "input btn width-100" }, "Submit")
				end)
			end)
			button({
				["x-show"] = "!editable",
				["@click"] = "editable = true",
				class = "input btn",
			}, "Change Password")
		end)
	end)
end)
