local map = vim.keymap.set
local settings = require 'config.settings'
--------------------------------------------------
-- BASIC OPERATIONS
--------------------------------------------------
-- @s replays the last "paste" as a visual selection.
-- We set this register lazily on the first TextYankPost so we don't trample
-- whatever the user already had in register 's' at startup.
vim.api.nvim_create_autocmd('TextYankPost', {
  once = true,
  callback = function()
    if vim.fn.getreg('s') == '' then
      vim.fn.setreg('s', "'[v']")
    end
  end,
})
-- Clear search highlight and terminal escape
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Definition navigation and file opening
map('n', 'gd', require 'config.lib.open_under', { desc = '_Definition (can open file under cursor)' })
map('n', '<leader>oo', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('tabnew ' .. file)
end, { desc = '[o]pen file under cursor' })
-- K -> vim.lsp.buf.hover() is a built-in default since 0.11

-- Window navigation
map('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-up>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-down>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggles
map('n', '<leader>tl', function()
  vim.o.linebreak = not vim.o.linebreak
end, { desc = '[l]ine break' })
map('n', '<leader>tw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'line [w]rap' })
map('n', '<leader>tm', function()
  require('treesj').toggle()
end, { desc = '[m]ultiline' })
map('n', '<leader>tn', '<cmd> set nonumber rnu! <CR>', { noremap = true, silent = true, desc = '[n]umber relative' })
map('n', '<leader>tN', '<cmd> set number! nornu <CR>', { noremap = true, silent = true, desc = '[N]umbering' })
map('n', '<leader>td', function()
  settings.showDiagnostics = not settings.showDiagnostics

  vim.diagnostic.enable(settings.showDiagnostics)

  if not settings.showDiagnostics and settings._diag_window then
    pcall(vim.api.nvim_win_close, settings._diag_window, true)
  end
  -- Spell is treated as another "lint noise" source and toggled together
  -- with diagnostics. Split into two keymaps if you want them independent.
  vim.o.spell = settings.showDiagnostics
end, { desc = '[d]iagnostics (+ spell)' })
