local function encrypt(string)
  local bcrypt = require("bcrypt")
  local log_rounds = 5
  local digest = bcrypt.digest(string, log_rounds)
  return digest
end
local function verify(string, digest)
  local bcrypt = require("bcrypt")
  return bcrypt.verify(string, digest)
end
local Users = require("models.users")

---@type ControllerTable
return {
  login = function(self)
    self.errors = {}
    return { render = "login" }
  end,
  login_post = function(self)
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
    return { render = "signup" }
  end,
  signup_post = function(self)
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
      Users:create({
        username = self.params.username,
        email = self.params.email,
        password = encrypt(self.params.password),
      })
      self.session.current_user = self.params.username
      return { redirect_to = self:url_for("index") }
    else
      return { render = "signup" }
    end
  end,
  settings = function(self)
    self.general_errors = {}
    self.password_errors = {}
    self.user = Users:find({
      username = self.session.current_user
    })
    return { render = "settings" }
  end,
  settings_general = function(self)
    self.general_errors = {}
    local user = Users:find({
      username = self.params.username,
      email = self.params.email
    })

    if next(user) then
      table.insert(self.general_errors, "This user already exists")
    end

    ---@TODO Fix User Login
    self.user = Users:find({ username = self.session.current_user })

    if #self.general_errors == 0 then
      user:update({
        username = self.params.username,
        email = self.params.email,
      })
      self.session.current_user = self.params.username
      return { redirect_to = self:url_for("settings") }
    else
      return { render = "settings" }
    end
  end,
  settings_password = function(self)
    local user = Users:find({
      username = self.session.current_user
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
      user:update({
        password = self.params.new_password
      })
      return { render = "settings" }
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
      username = self.session.current_user
    })
    user:delete()
    self.session.current_user = nil
    return { render = "index" }
  end
}
