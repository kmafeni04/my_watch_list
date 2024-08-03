---@type Model
local Model = require("lapis.db.model").Model
local CommentLikes, CommentLikes_mt = Model:extend("comment_likes")

return CommentLikes
