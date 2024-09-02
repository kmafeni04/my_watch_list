---@type Db
local db = require("lapis.db")

---@type Schema
local schema = require("lapis.db.schema")
local types = schema.types

local config = require("lapis.config").get()
local encrypt = require("misc.bcrypt").encrypt

return {
  [1] = function()
    schema.create_table("users", {
      { "id", (types.serial or types.integer) },
      { "username", types.text },
      { "email", types.text },
      { "password", types.text },

      "PRIMARY KEY (id)",
    })

    schema.create_index("users", "username", "email", { unique = true })

    schema.create_table("shows", {
      { "id", (types.serial or types.integer) },
      { "show_id", types.integer },
      { "user_id", types.integer },

      "PRIMARY KEY (id)",
    })

    schema.create_index("shows", "show_id", { unique = true })

    if config._name == "development" then
      local password = encrypt("testpassword")
      db.insert("users", {
        username = "testuser",
        email = "test@test.com",
        password = password,
      })
    end
  end,
  [2] = function()
    local id
    local date
    local like
    local dislike
    if config.postgres then
      id = types.serial({ primary_key = true })
      date = types.date
      like = types.boolean
      dislike = types.boolean
    else
      id = types.integer({ primary_key = true })
      date = types.text
      like = types.text
      dislike = types.text
    end
    schema.create_table("comments", {
      { "id", id },
      { "username", types.text },
      { "date", date },
      { "likes", types.integer },
      { "content", types.text },
      { "show_id", types.integer },
    })

    schema.create_table("comment_likes", {
      { "id", id },
      { "like", like },
      { "dislike", dislike },
      { "user_id", types.integer },
      { "comment_id", types.integer },
    })
  end,
  [3] = function()
    schema.add_column("shows", "watched", types.text)
  end,
}
