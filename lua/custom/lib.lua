return {
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
