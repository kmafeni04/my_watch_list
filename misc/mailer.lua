---@param username string
---@param password string
---@param from string
---@param to table
---@param subject string
---@param content string
local function mailer_func(username, password, from, to, subject, content)
  local mail = require "resty.mail"

  local mailer, new_err = mail.new({
    host = "smtp.gmail.com",
    port = 587,
    starttls = true,
    username = username,
    password = password,
  })
  if new_err then
    ngx.log(ngx.ERR, "mail.new error: ", new_err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end

  local _, send_err = mailer:send({
    from = from,
    to = to,
    subject = subject,
    html = content
  })
  if send_err then
    ngx.log(ngx.ERR, "mailer:send error: ", send_err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end
end
return mailer_func
