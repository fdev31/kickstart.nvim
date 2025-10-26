local M = {}

--- removes consecutive spaces and stops at the first 0 (^@) character.
M.clean_string = function(text, maxlen)
  local cleaned = text:gsub('%s+', ' ')
  local null_pos = cleaned:find '%z'
  if null_pos then
    cleaned = cleaned:sub(1, null_pos - 1)
  end
  if maxlen and #cleaned > maxlen then
    cleaned = cleaned:sub(1, maxlen - 3) .. '…'
  end
  return cleaned
end

M.is_buffer_tracked = function()
  local file_path = vim.fn.expand '%:p'
  if file_path == '' then
    return false
  end

  local git_dir = vim.fn.FugitiveGitDir()
  if git_dir == '' then
    return false
  end

  -- Use fugitive to check if file is tracked
  local status = vim.fn.FugitiveStatusline()
  -- If the file is not tracked, status would typically be empty or indicate untracked
  return status ~= '' and not status:match '%%%-' -- %- indicates untracked
end

M.strip = function(origin)
  return origin:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')
end

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
  local args = { ... }
  return function(...)
    local combined_args = {}
    for i, v in ipairs(args) do
      combined_args[i] = v
    end
    for i, v in ipairs { ... } do
      combined_args[#args + i] = v
    end
    return fn(unpack(combined_args))
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
