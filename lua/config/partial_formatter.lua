local _warning_displayed = false

-- https://github.com/stevearc/conform.nvim/issues/92
return function()
  local ignore_filetypes = { 'lua' }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    if not _warning_displayed then
      -- vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
    end
    return
  end

  local hunks = require('gitsigns').get_hunks()
  if hunks == nil then
    return
  end

  local format = require('conform').format

  local function format_range()
    if next(hunks) == nil then
      -- vim.notify('done formatting git hunks', 'info', { title = 'formatting' })
      return true
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
