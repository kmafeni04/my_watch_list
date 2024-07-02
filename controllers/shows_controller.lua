---@class Db
local db = require("lapis.db")
local json_handler = require("misc.json_handler")

---@class Model
local Shows = require("models.shows")

---@class Model
local Users = require("models.users")

return {
  shows = function(self)
    ---@class Model
    local user = Users:find({
      username = self.session.current_user
    })
    self.shows = {}
    local shows = Shows:select(db.clause({
      user_id = user.id
    }))
    for key, _ in pairs(shows) do
      table.insert(self.shows, json_handler("https://api.tvmaze.com/shows/", shows[key].show_id))
    end
    return { render = "shows.index" }
  end,
  search = function(self)
    self.shows = json_handler("https://api.tvmaze.com/search/shows?q=", self.params.query)
    return { render = "shows.search" }
  end,
  show_post = function(self)
    ---@class Model
    local user = Users:find({
      username = self.session.current_user
    })
    Shows:create({
      show_id = self.params.id,
      user_id = user.id
    })
    return { redirect_to = self:url_for("shows") }
  end,
  show_delete = function(self)
    ---@class Model
    local show = Shows:find({
      show_id = self.params.id
    })
    show:delete()
    self.shows = {}
    local shows = Shows:select()
    for key, _ in pairs(shows) do
      table.insert(self.shows, json_handler("https://api.tvmaze.com/shows/", shows[key].show_id))
    end
    -- return { redirect_to = self:url_for("shows") }
    return { render = "shows.index" }
  end
}
