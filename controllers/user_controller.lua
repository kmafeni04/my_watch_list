---@class Model
local Users = require("models.users")
return {
  login = function(self)
    self.errors = {}
    return { render = "login" }
  end,
  login_post = function(self)
    self.errors = {}
    local user = Users:find({ username = self.params.username, password = self.params.password })
    if user then
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
        password = self.params.password,
      })
      self.session.current_user = self.params.username
      return { redirect_to = self:url_for("index") }
    else
      return { render = "signup" }
    end
  end,
  logout = function(self)
    self.session.current_user = nil
    return { redirect_to = self:url_for("index") }
  end,
}
