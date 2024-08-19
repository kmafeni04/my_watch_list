---@class Db
local db = require("lapis.db")
local csrf_validate = require("lapis.csrf").validate_token
local json_handler = require("misc.json_handler")

---@type Model
local Users = require("models.users")
---@type Model
local Shows = require("models.shows")
---@type Model
local Comments = require("models.comments")
---@type Model
local CommentLikes = require("models.comment_likes")

---@type ControllerTable
return {
	shows = function(self)
		local user = Users:find({
			username = self.session.current_user,
		})
		self.shows = {}
		local shows = Shows:select(db.clause({
			user_id = assert(user).id,
		}))
		for key, _ in pairs(shows) do
			table.insert(self.shows, json_handler("https://api.tvmaze.com/shows/", tostring(shows[key].show_id)))
		end
		return { render = "shows.my_shows" }
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
				username = self.session.current_user,
			})
			self.show_in_db = Shows:find({
				show_id = self.params.id,
				user_id = assert(user).id,
			})
		end
		self.comments = Comments:select(db.clause({
			show_id = self.params.id,
		}))
		table.sort(self.comments, function(a, b)
			return a.id > b.id
		end)
		return { render = "shows.show" }
	end,
	show_button = function(self)
		local show_in_db = Shows:find({
			show_id = self.params.show_id,
		})
		self.reroute_url = self.params.reroute_url
		self.show = json_handler("https://api.tvmaze.com/shows/", self.params.show_id)
		if show_in_db and next(show_in_db) ~= nil then
			self.show_id = show_in_db.show_id
		end
		return self:write({ render = "widgets.show_button", layout = false })
	end,
	show_post = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		if self.session.current_user then
			local user = Users:find({
				username = self.session.current_user,
			})
			local show = Shows:find({
				show_id = self.params.id,
			})
			Shows:create({
				show_id = self.params.id,
				user_id = assert(user).id,
			})
			return self:write({ redirect_to = self.params.reroute_url })
		else
			return self:write({ redirect_to = self:url_for("login") })
		end
	end,
	show_delete = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		local show = Shows:find({
			show_id = self.params.id,
		})
		assert(show):delete()
		return self:write({ headers = { ["HX-Location"] = self.params.reroute_url } })
	end,
	airing = function(self)
		if self.params.date and self.params.date ~= os.date("%Y-%m-%d") then
			self.time = self.params.date
			self.day = self.params.date
		else
			self.time = os.date("%Y-%m-%d")
			self.day = "Today"
		end
		local shows_unsorted, err =
			json_handler("https://api.tvmaze.com/schedule", { date = self.time, country = self.params.country or "US" })
		if err then
			print(err)
		end
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
		return self:write({ render = "airing" })
	end,
	comments_post = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		Comments:create({
			username = self.session.current_user,
			date = os.date("%Y-%m-%d"),
			likes = 0,
			content = self.params.content,
			show_id = self.params.show_id,
		})
		self.comments = Comments:select(db.clause({
			show_id = self.params.show_id,
		}))
		table.sort(self.comments, function(a, b)
			return a.id > b.id
		end)
		return self:write({ render = "widgets.comments", layout = false })
	end,
	comment_delete = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		local comment = Comments:find({
			id = self.params.id,
		})
		local comment_like = CommentLikes:find({
			comment_id = assert(comment).id,
		})
		if comment_like then
			comment_like:delete()
		end
		assert(comment):delete()
	end,
	comment_likes_load = function(self)
		self.comment = Comments:find({
			id = self.params.id,
		})
		self.comment_likes = CommentLikes:find({
			comment_id = self.comment.id,
		})
		if self.comment_likes then
			if self.comment_likes.like == "0" then
				self.comment_likes.like = false
			elseif self.comment_likes.like == "1" then
				self.comment_likes.like = true
			else
				self.comment_likes.like = false
			end
			if self.comment_likes.dislike == "0" then
				self.comment_likes.dislike = false
			elseif self.comment_likes.dislike == "1" then
				self.comment_likes.dislike = true
			else
				self.comment_likes.dislike = false
			end
		else
			self.comment_likes = {}
			self.comment_likes.like = false
			self.comment_likes.dislike = false
		end
		return self:write({ render = "widgets.comment_likes", layout = false })
	end,
	comment_like = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		local user = Users:find({
			username = self.session.current_user,
		})
		self.comment = Comments:find({
			id = self.params.id,
		})
		self.comment_likes = CommentLikes:find({
			comment_id = self.comment.id,
		})
		if self.comment_likes and self.comment_likes.like == ("1" or true) then
			self.comment_likes:update({
				like = false,
				dislike = false,
			})
			self.comment:update({
				likes = self.comment.likes - 1,
			})
		elseif
			self.comment_likes
			and self.comment_likes.dislike == ("1" or true)
			and self.comment_likes.like == ("0" or false)
		then
			self.comment_likes:update({
				dislike = false,
				like = true,
			})
			self.comment:update({
				likes = self.comment.likes + 2,
			})
		elseif self.comment_likes and self.comment_likes.like == ("0" or false) then
			self.comment_likes:update({
				like = true,
				dislike = false,
			})
			self.comment:update({
				likes = self.comment.likes + 1,
			})
		else
			CommentLikes:create({
				user_id = assert(user).id,
				comment_id = self.comment.id,
				like = true,
				dislike = false,
			})
			self.comment_likes = CommentLikes:find({
				user_id = assert(user).id,
				comment_id = self.comment.id,
			})
			self.comment_likes.dislike = false
			self.comment:update({
				likes = self.comment.likes + 1,
			})
		end
		return self:write({ render = "widgets.comment_likes", layout = false })
	end,
	comment_dislike = function(self)
		if not csrf_validate(self) then
			return self:write({ status = 403 })
		end
		local user = Users:find({
			username = self.session.current_user,
		})
		self.comment = Comments:find({
			id = self.params.id,
		})
		self.comment_likes = CommentLikes:find({
			user_id = assert(user).id,
			comment_id = self.comment.id,
		})
		if self.comment_likes and self.comment_likes.dislike == ("1" or true) then
			self.comment_likes:update({
				like = false,
				dislike = false,
			})
			self.comment:update({
				likes = self.comment.likes + 1,
			})
		elseif
			self.comment_likes
			and self.comment_likes.like == ("1" or true)
			and self.comment_likes.dislike == ("0" or false)
		then
			self.comment_likes:update({
				dislike = true,
				like = false,
			})
			self.comment:update({
				likes = self.comment.likes - 2,
			})
		elseif self.comment_likes and self.comment_likes.dislike == ("0" or false) then
			self.comment_likes:update({
				dislike = true,
				like = false,
			})
			self.comment:update({
				likes = self.comment.likes - 1,
			})
		else
			CommentLikes:create({
				user_id = assert(user).id,
				comment_id = self.comment.id,
				like = false,
				dislike = true,
			})
			self.comment_likes = CommentLikes:find({
				user_id = assert(user).id,
				comment_id = self.comment.id,
			})
			self.comment_likes.like = false
			self.comment:update({
				likes = self.comment.likes - 1,
			})
		end
		return self:write({ render = "widgets.comment_likes", layout = false })
	end,
}
