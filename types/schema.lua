---@class Schema
local schema = {
  ---@class Schema.types
  types = {
    ---@param opts? table|nil
    boolean = function(opts)
    end,
    ---@param opts? table|nil
    date = function(opts)
    end,
    ---@param opts? table|nil
    double = function(opts)
    end,
    ---@param opts? table|nil
    foreign_key = function(opts)
    end,
    ---@param opts? table|nil
    integer = function(opts)
    end,
    ---@param opts? table|nil
    numeric = function(opts)
    end,
    ---@param opts? table|nil
    real = function(opts)
    end,
    ---@param opts? table|nil
    serial = function(opts)
    end,
    ---@param opts? table|nil
    text = function(opts)
    end,
    ---@param opts? table|nil
    time = function(opts)
    end,
    ---@param opts? table|nil
    varchar = function(opts)
    end,
    ---@param opts? table|nil
    enum = function(opts)
    end,
  },
  ---@param table_name string
  ---@param table_declarations table
  create_table = function(table_name, table_declarations)
  end,
  ---@param table_name string
  drop_table = function(table_name)
  end,
  ---@param table_name string
  ---@param col string
  ---@param ...? any
  create_index = function(table_name, col, ...)
  end,
  ---@param table_name string
  ---@param col1 string
  ---@param col2 string
  ---@param ... any
  drop_index = function(table_name, col1, col2, ...)
  end,
  ---
  ---@param table_name string
  ---@param column_name string
  ---@param column_type Schema.types
  add_column = function(table_name, column_name, column_type)
  end,
  ---@param table_name string
  ---@param column_name string
  drop_column = function(table_name, column_name)
  end,
  ---@param table_name string
  ---@param old_name string
  ---@param new_name string
  rename_column = function(table_name, old_name, new_name)
  end,
  ---@param old_name string
  ---@param new_name string
  rename_table = function(old_name, new_name)
  end,
}
