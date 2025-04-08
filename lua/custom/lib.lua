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
    local file_under_cursor = vim.fn.expand('<cfile>'):gsub('^~', vim.env.HOME or os.getenv 'HOME')
    local current_pos = { vim.fn.line '.', vim.fn.col '.' }
    local current_buf = vim.api.nvim_get_current_buf()

    -- Try LSP definition
    local result = vim.lsp.buf_request_sync(0, 'textDocument/definition', vim.lsp.util.make_position_params(), 500)

    if result and next(result) then
      for _, res in pairs(result) do
        if res.result and #res.result > 0 then
          return vim.lsp.buf.definition()
        end
      end
    end

    -- Check if the file exists and is readable
    if vim.fn.filereadable(file_under_cursor) or vim.fn.isdirectory(file_under_cursor) then
      vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
    else
      vim.notify('Could not find ' .. file_under_cursor, vim.log.levels.WARN)
    end
  end,
  isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil,
}
