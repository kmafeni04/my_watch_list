---@type Widget
local Widget = require("lapis.html").Widget

local interp = require("misc.interp")

return Widget:extend(function(self)
  div({ class = "settings flex-col gap-m height-max" }, function()
    div({ class = "settings__general grid-center gap-s" }, function()
      h2("General")
      form({
        id = "details-form",
        action = self:url_for("settings"),
        method = "POST",
        ["hx-confirm"] = "Are you sure you would like to make these changes?",
        ["hx-indicator"] = "#loading",
        class = "settings-form grid gap-s",
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
        local username = self.user.username
        input({
          id = "username",
          name = "username",
          _ = interp([[on load set my @value to "{{username}}" then add @disabled to me]]),
          class = "input",
          required = true,
        })
        label({
          ["for"] = "email",
        }, "Email:")
        local email = self.user.email
        input({
          id = "email",
          name = "email",
          _ = interp([[on load set my @value to "{{email}}" then add @disabled to me]]),
          class = "input",
          required = true,
        })
        button({
          type = "button",
          _ = [[
            on click 
            remove @disabled from #username
            remove @disabled from #email
            show .settings-form__buttons
            add .flex to #details-confirm-submit
            hide me
            ]],
          class = "settings-form__edit-btn input btn width-100",
        }, "Edit")
        div({
          id = "details-confirm-submit",
          class = "settings-form__buttons hidden align-center gap-s",
        }, function()
          button({
            type = "button",
            _ = [[
              on click
              add @disabled to #username
              add @disabled to #email
              show .settings-form__edit-btn
              hide #details-confirm-submit
              ]],
            class = "input btn width-100",
          }, "Cancel")
          button({
            type = "submit",
            class = "input btn width-100",
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
      button({
        id = "change-password-btn",
        class = "input btn",
        _ = [[
            on click
            show #password-form
            add .grid to #password-form
            hide me
          ]],
      }, "Change Password")
      form({
        id = "password-form",
        ["hx-put"] = self:url_for("change_password"),
        ["hx-target"] = "body",
        ["hx-indicator"] = "#loading",
        class = "hidden gap-s",
      }, function()
        label({
          ["for"] = "current-password",
        }, "Current Password:")
        input({
          type = "password",
          name = "current_password",
          id = "current-password",
          class = "input",
          required = true,
        })
        label({
          ["for"] = "new-password",
        }, "New Password:")
        input({
          type = "password",
          name = "new_password",
          id = "new-password",
          class = "input",
          required = true,
        })
        label({
          ["for"] = "confirm-new-password",
        }, "Confirm New Password:")
        input({
          type = "password",
          name = "confirm_new_password",
          id = "confirm-new-password",
          class = "input",
          required = true,
        })
        div({ class = "show-password flex align-center gap-xs" }, function()
          label({ ["for"] = "show-password-check" }, "Show Password")
          input({
            type = "checkbox",
            autocomplete = "off",
            _ = [[
                on click
                for input in [#current-password, #new-password, #confirm-new-password]
                  if input's @type is "password" then
                    set input's @type to "text"
                  else
                    set input's @type to "password"
                  end
                end
              ]],
          })
        end)
        div({ id = "password-confirm-edit", class = "settings-form__buttons flex align-center gap-s" }, function()
          button({
            type = "button",
            class = "input btn width-100",
            _ = [[
                on click
                hide #password-form
                show #change-password-btn
              ]],
          }, "Cancel")
          button({ class = "input btn width-100" }, "Submit")
        end)
      end)
    end)
  end)
end)
