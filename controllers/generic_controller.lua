---@type ControllerTable
return {
  root = function(self)
    return self:write({ render = true })
  end,
}
