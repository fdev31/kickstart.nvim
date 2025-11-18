local ignore_filetypes = { 'lua' }

-- https://github.com/stevearc/conform.nvim/issues/92
-- Format only the git changed hunks in the current buffer
-- Returns false if this filetype can't be formatted, true otherwise
return function()
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    return false
  end

  -- Fix: get_hunks() requires buffer number argument
  local hunks = require('gitsigns').get_hunks()
  if hunks == nil or #hunks == 0 then
    vim.notify('No change detected', vim.log.levels.INFO, { title = 'formatting' })
    return true
  end

  local format = require('conform').format

  local function format_range()
    if not next(hunks) then
      -- vim.notify('done formatting git hunks', vim.log.levels.INFO, { title = 'formatting' })
      return true
    end

    local hunk
    repeat
      hunk = table.remove(hunks, 1)
    until not hunk or hunk.type ~= 'delete'

    if hunk then
      local start_line = hunk.added.start - 1
      local end_line = 1 + start_line + hunk.added.count

      -- vim.notify('start_line: ' .. start_line .. ' end_line: ' .. end_line, vim.log.levels.INFO, { title = 'formatting' })

      -- Ensure we don't try to format an empty range
      if end_line < start_line then
        vim.defer_fn(format_range, 1)
        return
      end

      local range = {
        start = { start_line, 0 },
        ['end'] = { end_line, 0 },
      }
      -- For single line changes, format the whole line.
      -- For multi-line, format up to the beginning of the last line.
      -- This is safer than using col=-1 which can cause issues on empty lines.
      if start_line ~= end_line then
        range['end'] = { end_line, 0 }
      else
        range['end'] = { end_line, -1 }
      end

      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(format_range, 1)
      end)
    end
  end

  return format_range()
end
