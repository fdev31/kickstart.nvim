local map = vim.keymap.set
local settings = require 'custom.settings'
--------------------------------------------------
-- BASIC OPERATIONS
--------------------------------------------------
-- Clear search highlight and terminal escape
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Definition navigation and file opening
map('n', 'gd', require('custom.lib').openUnder, { desc = '_Definition (can open file under cursor)' })
map('n', '<leader>oo', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('tabnew ' .. file)
end, { desc = '[o]pen file under cursor' })
map('n', 'K', function()
  vim.lsp.buf.hover()
end, { buffer = bufnr, desc = 'LSP symbol doc' })

-- Window navigation
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggles
map('n', '<leader>tm', require('treesj').toggle, { desc = '[m]ultiline' })
map('n', '<leader>tn', '<cmd> set nonumber rnu! <CR>', { noremap = true, silent = true, desc = '[n]umber relative' })
map('n', '<leader>tN', '<cmd> set number! nornu <CR>', { noremap = true, silent = true, desc = '[N]umbering' })
map('n', '<leader>td', function()
  settings.showDiagnostics = not settings.showDiagnostics

  vim.diagnostic.enable(settings.showDiagnostics)

  if not settings.showDiagnostics and settings._diag_window then
    vim.api.nvim_win_close(settings._diag_window, true)
  end
  vim.o.spell = settings.showDiagnostics
end, { desc = '[d]iagnostics' })
map('n', '<leader>ti', require('dapui').toggle, { noremap = true, silent = true, desc = '[i]nspector' })
