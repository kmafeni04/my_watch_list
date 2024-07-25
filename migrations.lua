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
      { "id",       (types.serial or types.integer) },
      { "username", types.text },
      { "email",    types.text },
      { "password", types.text },

      "PRIMARY KEY (id)"
    })

    schema.create_index("users", "username", "email", { unique = true })

    schema.create_table("shows", {
      { "id",      (types.serial or types.integer) },
      { "show_id", types.integer },
      { "user_id", types.integer },

      "PRIMARY KEY (id)"
    })

    schema.create_index("shows", "show_id", { unique = true })
    if config._name == "development" then
      local password = encrypt("testpassword")
      db.insert("users", {
        username = "testuser",
        email = "test@test.com",
        password = password
      })
    end
  end,
  [2] = function()
    schema.create_table("comments", {
      { "id",       (types.serial or types.integer) },
      { "username", types.text },
      { "date",     (types.date or types.text) },
      { "likes",    types.integer },
      { "content",  types.text },
      { "show_id",  types.integer },

      "PRIMARY KEY (id)"
    })
  end
}
