return {
  -- This is a collection of utility functions for various tasks.
  -- partial function supports think "functools.partial" in python
  partial = function(fn, ...)
    local n, args = select('#', ...), { ... }
    return function()
      return fn(unpack(args, 1, n))
    end
  end,
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
  --- Appends positional elements of table `t2` to table `t1`.
  -- @param t1 The table to which elements will be appended.
  -- @param t2 The table containing elements to append.
  -- @return The modified table `t1` with elements of `t2` appended.
  textend = function(t1, t2)
    for _, v in ipairs(t2) do
      table.insert(t1, v)
    end
    return t1
  end,
  --- Appends every elements of table `t2` to table `t1`.
  -- @param t1 The table to which elements will be appended.
  -- @param t2 The table containing elements to append.
  -- @return The modified table `t1` with elements of `t2` appended.
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
  openUnder = function()
    -- Try LSP definition
    local result = vim.lsp.buf_request_sync(0, 'textDocument/definition', vim.lsp.util.make_position_params(), 500)

    if result and next(result) then
      for _, res in pairs(result) do
        if res.result and #res.result > 0 then
          return vim.lsp.buf.definition()
        end
      end
    end
    local file_under_cursor = vim.fn.fnamemodify(vim.fn.expand '<cfile>', ':p')
    -- Check if the file exists and is readable
    if vim.fn.filereadable(file_under_cursor) or vim.fn.isdirectory(file_under_cursor) then
      vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
    else
      vim.notify('Could not find ' .. file_under_cursor, vim.log.levels.WARN)
    end
  end,
  isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil,

  filter_prop = function(list, propname, not_value)
    local filtered = {}
    for _, item in ipairs(list) do
      if item[propname] ~= not_value then
        table.insert(filtered, item)
      end
    end
    return filtered
  end,
  safeString = function(str)
    if not str then
      return ' '
    end
    if type(str) == 'string' then
      return str
    else
      return vim.inspect('^%s*(.-)%s*$', '%1')
    end
  end,
}
