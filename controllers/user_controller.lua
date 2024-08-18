local csrf_validated = require("lapis.csrf").validate_token

local encrypt = require("misc.bcrypt").encrypt
local verify = require("misc.bcrypt").verify
local mailer = require("misc.mailer")
local Users = require("models.users")

---@type ControllerTable
return {
	login = function(self)
		self.errors = {}
		return self:write({ render = "login" })
	end,
	login_post = function(self)
		if not csrf_validated(self) then
			return "csrf warning"
		end
		self.errors = {}
		local user = Users:find({ username = self.params.username })
		if user and verify(self.params.password, user.password) then
			self.session.current_user = self.params.username
			return { redirect_to = self:url_for("index") }
		else
			table.insert(self.errors, "Username or password is incorrect")
			return { render = "login" }
		end
	end,
	signup = function(self)
		self.errors = {}
		return self:write({ render = "signup" })
	end,
	signup_post = function(self)
		if not csrf_validated(self) then
			return "csrf warning"
		end
		self.errors = {}
		local user = Users:find({
			username = self.params.username,
			email = self.params.email,
		})
		if self.params.password ~= self.params.confirm_password then
			table.insert(self.errors, "Passwords do not match")
		end
		if user then
			table.insert(self.errors, "This user already exists")
		end
		if #self.errors == 0 then
			math.randomseed(os.time())
			self.session.signup_code = math.random(1000, 9999)
			mailer(
				assert(os.getenv("GMAIL_EMAIL")),
				assert(os.getenv("GMAIL_PASSWORD")),
				string.format("Leonard Mafeni <%s>", assert(os.getenv("GMAIL_EMAIL"))),
				{ self.params.email },
				"Registration",
				string.format(
					[[
          <p>Your Sign Up code is: </p>
          <h1>%s</h1>
        ]],
					self.session.signup_code
				)
			)
			return { render = "signup_code_sent" }
		else
			return { render = "signup" }
		end
	end,
	signup_complete = function(self)
		print(self.params.signup_code)
		print(self.session.signup_code)
		if tonumber(self.params.signup_code) == tonumber(self.session.signup_code) then
			Users:create({
				username = self.params.username,
				email = self.params.email,
				password = self.params.password,
			})
			self.session.current_user = self.params.username
			self.session.signup_code = nil
			return self:write({ redirect_to = self:url_for("index") })
		else
			return self:write({ render = "signup_code_sent" })
		end
	end,
	forgot_password = function(self)
		return self:write({ render = "forgot_password" })
	end,
	forgot_password_post = function(self)
		local user = Users:find({
			email = self.params.email,
		})
		if type(user) ~= "table" or next(user) == nil then
			return "This email doesn't exist"
		else
			self.session.reset_email = self.params.email
			math.randomseed(os.time())
			self.session.reset_code = math.random(1000, 9999)
			mailer(
				assert(os.getenv("GMAIL_EMAIL")),
				assert(os.getenv("GMAIL_PASSWORD")),
				string.format("leonard mafeni <%s>", assert(os.getenv("GMAIL_EMAIL"))),
				{ self.params.email },
				"Password Reset",
				string.format(
					[[
            <p>do not reply this email</p>
            <p>your reset code is:</p>
            <h2>%s</h2>
            <p>if you did not request to reset, kindly ignore this and nothing will be changed</p>
          ]],
					self.session.reset_code
				)
			)
			return self:write({ render = "password_reset_sent" })
		end
	end,
	password_reset_sent = function(self)
		print("the reset code is " .. self.session.reset_code)
		print("the user inputted code is " .. self.params.code)
		if tonumber(self.params.code) == tonumber(self.session.reset_code) then
			return self:write({ render = "password_reset_form" })
		else
			return self:write({ render = "password_reset_sent" })
		end
	end,
	password_reset = function(self)
		local user = Users:find({
			email = self.session.reset_email,
		})
		if self.params.new_password == self.params.confirm_password then
			local password = encrypt(self.params.new_password)
			user:update({
				password = password,
			})
			self.session.reset_email = nil
			self.session.reset_code = nil
			return self:write({ redirect_to = self:url_for("login") })
		else
			return self:write({ render = "password_reset_form" })
		end
	end,
	settings = function(self)
		self.general_errors = {}
		self.password_errors = {}
		self.user = Users:find({
			username = self.session.current_user,
		})
		return { render = "settings" }
	end,
	settings_general = function(self)
		self.general_errors = {}
		local user_username = Users:find({
			username = self.params.username,
		})
		local user_email = Users:find({
			email = self.params.email,
		})

		if user_username and next(user_username) and user_username.username ~= self.params.username then
			table.insert(self.general_errors, "This username already exists")
		end
		if user_email and next(user_email) and user_email.email ~= self.params.email then
			table.insert(self.general_errors, "This email already exists")
		end

		local user = Users:find({ username = self.session.current_user })
		self.user = user

		if #self.general_errors == 0 then
			user:update({
				username = self.params.username,
				email = self.params.email,
			})
			self.session.current_user = self.params.username
			return { headers = { ["HX-Location"] = self:url_for("settings") } }
		else
			return { render = "settings" }
		end
	end,
	settings_password = function(self)
		local user = Users:find({
			username = self.session.current_user,
		})
		self.password_errors = {}
		self.user = Users:find({ username = self.session.current_user })
		if not verify(self.params.current_password, user.password) then
			table.insert(self.password_errors, "That is not the current password")
		end
		if self.params.current_password == self.params.new_password then
			table.insert(self.password_errors, "New password can not be the same as current")
		end
		if self.params.new_password ~= self.params.confirm_new_password then
			table.insert(self.password_errors, "Passwords do not match")
		end

		if #self.password_errors == 0 then
			local password = encrypt(self.params.new_password)
			user:update({
				password = password,
			})
			return { headers = { ["HX-Location"] = self:url_for("settings") } }
		else
			return { render = "settings" }
		end
	end,
	logout = function(self)
		self.session.current_user = nil
		return { redirect_to = self:url_for("index") }
	end,
	delete_account = function(self)
		local user = Users:find({
			username = self.session.current_user,
		})
		user:delete()
		self.session.current_user = nil
		return self:write({ headers = { ["HX-Location"] = self:url_for("index") } })
	end,
}
