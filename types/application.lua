--- Lapis module
---@class Lapis
local lapis = {
  Application = function()
  end
}

--- Lapis Application
---@class App
local app = {
  layout = nil,
}

---@param feature string
function app:enable(feature)
end

---
---@param fn function
function app:before_filter(fn)
end

---@param route_name? string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:match(route_name, route_path, action_fn)
  return {}
end

---@param route_name string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:get(route_name, route_path, action_fn)
  return {}
end

---@param route_name string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:post(route_name, route_path, action_fn)
  return {}
end

---@param route_name string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:patch(route_name, route_path, action_fn)
  return {}
end

---@param route_name string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:put(route_name, route_path, action_fn)
  return {}
end

---@param route_name string|nil
---@param route_path string
---@param action_fn function
---@return any
function app:delete(route_name, route_path, action_fn)
  return {}
end
