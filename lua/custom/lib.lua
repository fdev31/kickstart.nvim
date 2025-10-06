local M = {
  floating_win_exists = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return true
      end
    end
    return false
  end,
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
  isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil,

  filter_prop = function(list, propname, not_value)
    local filtered = {}
    for name, item in pairs(list) do
      if item[propname] ~= not_value then
        filtered[name] = item
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
M.openUnder = function()
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
  if M.file_exists(file_under_cursor) then
    vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
  else
    vim.notify('Could not find ' .. file_under_cursor, vim.log.levels.WARN)
  end
end

-- https://github.com/stevearc/conform.nvim/issues/92
M.formatChangedLines = function()
  local ignore_filetypes = { 'lua' }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
    return
  end

  local hunks = require('gitsigns').get_hunks()
  if hunks == nil then
    return
  end

  local format = require('conform').format

  local function format_range()
    if next(hunks) == nil then
      vim.notify('done formatting git hunks', 'info', { title = 'formatting' })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
      hunk = table.remove(hunks)
    end

    if hunk ~= nil and hunk.type ~= 'delete' then
      local start = hunk.added.start
      local last = start + hunk.added.count
      -- show "start , end"
      -- vim.notify(string.format("%s,%s", start, last), 'info', { title = 'formatting' })
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(function()
          format_range()
        end, 1)
      end)
    end
  end

  format_range()
end

return M
