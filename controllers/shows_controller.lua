---@class Db
local db = require("lapis.db")
local json_handler = require("misc.json_handler")

---@type Model
local Users = require("models.users")
---@type Model
local Shows = require("models.shows")
---@type Model
local Comments = require("models.comments")

---@type ControllerTable
return {
  shows = function(self)
    local user = Users:find({
      username = self.session.current_user
    })
    self.shows = {}
    local shows = Shows:select(db.clause({
      user_id = assert(user).id
    }))
    for key, _ in pairs(shows) do
      table.insert(self.shows, json_handler("https://api.tvmaze.com/shows/", tostring(shows[key].show_id)))
    end
    return { render = "shows.index" }
  end,
  search = function(self)
    if not self.params.query then
      self.params.query = ""
      self.shows = {}
    else
      self.shows = json_handler("https://api.tvmaze.com/search/shows?q=", self.params.query)
    end
    return { render = "shows.search" }
  end,
  show = function(self)
    self.show = json_handler("https://api.tvmaze.com/shows/", self.params.id)
    local user
    if self.session.current_user then
      user = Users:find({
        username = self.session.current_user
      })
      self.show_in_db = Shows:find({
        show_id = self.params.id,
        user_id = assert(user).id
      })
    end
    self.comments = Comments:select(db.clause({
      show_id = self.params.id
    }))
    table.sort(self.comments, function(a, b)
      return a.id > b.id
    end)
    return { render = "shows.show" }
  end,
  comments_post = function(self)
    Comments:create({
      username = self.session.current_user,
      date = os.date("%Y-%m-%d"),
      likes = 0,
      content = self.params.content,
      show_id = self.params.show_id
    })
    self.comments = Comments:select(db.clause({
      show_id = self.params.show_id
    }))
    table.sort(self.comments, function(a, b)
      return a.id > b.id
    end)
    return self:write({ render = "partials.comments", layout = false })
  end,
  comment_delete = function(self)
    local comment = Comments:find({
      id = self.params.id
    })
    assert(comment):delete()
  end,
  show_post = function(self)
    if self.session.current_user then
      local user = Users:find({
        username = self.session.current_user
      })
      Shows:create({
        show_id = self.params.id,
        user_id = assert(user).id
      })
      return { redirect_to = self:url_for("shows") }
    else
      return self:write({ redirect_to = self:url_for("login") })
    end
  end,
  show_delete = function(self)
    local show = Shows:find({
      show_id = self.params.id
    })
    show:delete()
    self.shows = {}
    local shows = Shows:select()
    for key, _ in pairs(shows) do
      table.insert(self.shows, json_handler("https://api.tvmaze.com/shows/", tostring(shows[key].show_id)))
    end
    return { headers = { ["HX-Location"] = self:url_for("shows") } }
  end,
  airing = function(self)
    if self.params.date and self.params.date ~= os.date("%Y-%m-%d") then
      self.time = self.params.date
      self.day = self.params.date
    else
      self.time = os.date("%Y-%m-%d")
      self.day = "Today"
    end
    local shows_unsorted = json_handler("https://api.tvmaze.com/schedule",
      { date = self.time, country = self.params.country or "US" })
    table.sort(shows_unsorted, function(a, b)
      if type(a.show.rating.average) == "userdata" then
        a.show.rating.average = 0
      end
      if type(b.show.rating.average) == "userdata" then
        b.show.rating.average = 0
      end
      return a.show.rating.average > b.show.rating.average
    end)
    self.shows = {}
    local counter = 0
    for key, _ in pairs(shows_unsorted) do
      local show = shows_unsorted[key].show
      table.insert(self.shows, show)
      counter = counter + 1
      if counter == 5 then
        break
      end
    end
    return { render = "airing" }
  end
}
