local M = {}

M.floating_win_exists = function()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return true
    end
  end
  return false
end

-- This is a collection of utility functions for various tasks.
-- partial function supports think "functools.partial" in python
M.partial = function(fn, ...)
  local n, args = select('#', ...), { ... }
  return function()
    return fn(unpack(args, 1, n))
  end
end

M.dump_json = function(obj)
  -- dump a serialized JSON string of diagnostics in /tmp/dump.json
  local file = io.open('/tmp/dump.json', 'w')
  if file then
    file:write(vim.inspect(obj))
    file:close()
  end
end

M.file_exists = function(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

--- Appends positional elements of table `t2` to table `t1`.
-- @param t1 The table to which elements will be appended.
-- @param t2 The table containing elements to append.
-- @return The modified table `t1` with elements of `t2` appended.
M.textend = function(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

--- Appends every elements of table `t2` to table `t1`.
-- @param t1 The table to which elements will be appended.
-- @param t2 The table containing elements to append.
-- @return The modified table `t1` with elements of `t2` appended.
M.extend = function(t1, t2)
  -- append every entry of table t2 to t1
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

M.has = function(tbl, item)
  for _, v in ipairs(tbl) do
    if v == item then
      return true
    end
  end
  return false
end

M.filter_prop = function(list, propname, not_value)
  local filtered = {}
  for name, item in pairs(list) do
    if item[propname] ~= not_value then
      filtered[name] = item
    end
  end
  return filtered
end

return M
