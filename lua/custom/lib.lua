return {
  dump_json = function(obj)
    -- dump a serialized JSON string of diagnostics in /tmp/dump.json
    local file = io.open('/tmp/dump.json', 'w')
    if file then
      file:write(vim.inspect(obj))
      file:close()
    end
  end,
  file_exists = function(name)
    local f = io.open(name, 'r')
    if f ~= nil then
      io.close(f)
      return true
    else
      return false
    end
  end,
  extend = function(t1, t2)
    -- append every entry of table t2 to t1
    for _, v in pairs(t2) do
      table.insert(t1, v)
    end
    return t1
  end,
  has = function(tbl, item)
    for _, v in ipairs(tbl) do
      if v == item then
        return true
      end
    end
    return false
  end,
  isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil,
}
