---@class Model
local model = {}

---@param ... any
function model:find(...)
end

---@param query? string|table
---@param ...? string|table
---@return table
function model:select(query, ...)
end

---@param primary_keys table
function model:find_all(primary_keys)
end

---@param clause string|nil
---@param ... string|number
function model:count(clause, ...)
end

---@param values table
---@param create_opts? table
function model:create(values, create_opts)
end

function model:columns()
end

function model:table_name()
end

function model:singular_name()
end

---
---@param objects table
---@param key string
---@param opts? table
function model:include_in(objects, key, opts)
end

---@param query string
---@param ... any
function model:paginated(query, ...)
end

---@param name string
function model:get_relation_model(name)
end

---@param table_name string
---@param fields table|nil
function model:extend(table_name, fields)
end

---@param ... any
function model:update(...)
end

---@param ... any
function model:delete(...)
end

---@param ... any
function model:refresh(...)
end

---@param ... any
function model:url_key(...)
end
