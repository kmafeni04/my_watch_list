local Widget = require("lapis.html").Widget

return Widget:extend(function(self)
	div({ class = "comments grid-center gap-m", id = "comments" }, function()
		p({ class = "htmx-indicator", id = "commenting" }, "Commenting...")
		if type(self.comments) == "table" and next(self.comments) ~= nil then
			for _, comment in pairs(self.comments) do
				div({ class = "comment grid align-start gap-xs" }, function()
					div({ class = "comment__header flex-center gap-xs" }, function()
						h3(comment.username)
						p(function()
							text("on ")
							span(comment.date)
						end)
						div({
							id = "comment-likes",
							class = "likes flex-center gap-xs",
							["hx-get"] = self:url_for("comment_likes_load", { id = comment.id }),
							["hx-trigger"] = "load",
						})
					end)
					pre(comment.content)
					if comment.username == self.session.current_user then
						form({
							["hx-delete"] = self:url_for("comment", { id = comment.id }),
							["hx-swap"] = "delete",
							["hx-target"] = "closest .comment",
							["hx-confirm"] = "Are you sure you would like to delete this comment",
						}, function()
							widget(self.csrf)
							button({ class = "input btn width-100" }, "Delete")
						end)
					end
				end)
			end
		else
			h3("No comments yet")
		end
	end)
end)
