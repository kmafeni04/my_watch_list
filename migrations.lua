---@class Db
local db = require("lapis.db")
---@class Schema
local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1] = function()
    schema.create_table("users", {
      { "id",       types.integer },
      { "username", types.text },
      { "email",    types.text },
      { "password", types.text },

      "PRIMARY KEY (id)"
    })

    schema.create_index("users", "username", "email", { unique = true })

    schema.create_table("shows", {
      { "id",      types.integer },
      { "show_id", types.integer },
      { "user_id", types.integer },

      "PRIMARY KEY (id)"
    })

    schema.create_index("shows", "show_id", { unique = true })

    db.insert("users", {
      username = "kmafeni04",
      email = "test@gmail.com",
      password = "aPassword*"
    })
  end
}
