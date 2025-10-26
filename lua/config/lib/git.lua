local M = {}
M.get_fugitive_windows = function()
  local fugitive_wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)

    if bufname:match '^fugitive://' then
      table.insert(fugitive_wins, win)
    end
  end
  return fugitive_wins
end

M.has_fugitive_diff = function()
  return #M.get_fugitive_windows() > 0
end

M.close_diff_view = function()
  if vim.g._diffview_enabled then
    if package.loaded.diffview then
      if next(require('diffview.lib').views) == nil then
        return false
      else
        package.loaded.diffview.close()
        return true
      end
    end
  end
  local ret = false
  for _, win in ipairs(M.get_fugitive_windows()) do
    vim.api.nvim_win_close(win, false)
    ret = true
  end
  if ret then
    -- Turn off diff mode in remaining windows
    vim.cmd 'diffoff!'
  end
  return ret
end

return M
