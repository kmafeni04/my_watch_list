---@type Widget
local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
  button({
    class = "input btn comment__like-btn",
    ["hx-post"] = self:url_for("comment_like", { id = self.comment.id }),
    ["hx-target"] = "closest #comment-likes",
    ["hx-indicator"] = true,
    ["hx-include"] = "find input",
    ["data-clicked"] = self.comment_likes.like,
  }, function()
    widget(self.csrf)
    i({ class = "like-icon nf nf-md-thumb_up" })
    i({ class = "htmx-indicator nf nf-fa-circle_notch", id = "liked" })
  end)
  p({ id = "comment-likes" }, self.comment.likes)
  button({
    class = "input btn comment__dislike-btn",
    ["hx-post"] = self:url_for("comment_dislike", { id = self.comment.id }),
    ["hx-target"] = "closest #comment-likes",
    ["hx-indicator"] = true,
    ["hx-include"] = "find input",
    ["data-clicked"] = self.comment_likes.dislike,
  }, function()
    widget(self.csrf)
    i({ class = "dislike-icon nf nf-md-thumb_down" })
    i({ class = "htmx-indicator nf nf-fa-circle_notch", id = "disliked" })
  end)
end)
