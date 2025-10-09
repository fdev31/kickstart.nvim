local M = {}

M.dump_json = function(obj)
  -- dump a serialized JSON string of diagnostics in /tmp/dump.json
  local file = io.open('/tmp/dump.json', 'w')
  if file then
    file:write(vim.inspect(obj))
    file:close()
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

M.isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil

M.safeString = function(str)
  if not str then
    return ' '
  end
  if type(str) == 'string' then
    return str
  else
    return vim.inspect('^%s*(.-)%s*$', '%1')
  end
end
