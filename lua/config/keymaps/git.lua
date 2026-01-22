local partial = require('config.lib.core').partial
local git = require 'config.lib.git'
local settings = require 'config.settings'
local map = vim.keymap.set

local telescope = require 'telescope.builtin'

--------------------------------------------------
-- GIT OPERATIONS
--------------------------------------------------
-- Navigate conflicts with ]x and [x (custom: jumps to next/prev conflict marker)
map('n', ']x', function()
  vim.cmd 'silent! normal! ]x'
  -- Fallback: search for next <<<<<<< if vim-unimpaired not installed
  if vim.v.hlsearch == 0 then
    vim.cmd 'silent! /<<<<<<<'
  end
end, { desc = 'Next conflict' })
map('n', '[x', function()
  vim.cmd 'silent! normal! [x'
  -- Fallback: search for prev <<<<<<<
  if vim.v.hlsearch == 0 then
    vim.cmd 'silent! ?>>>>>>>'
  end
end, { desc = 'Previous conflict' })

-- Toggle diff view
map('n', '<leader>D', function()
  if not git.close_diff_view() then
    vim.cmd(settings.diff_command .. ' HEAD')
  end
end, { desc = 'Diff view (toggle)' })

map('n', '<C-Space>', require('gitsigns').stage_hunk, { desc = 'stage/unstage hunk (git)' })
map('n', '<leader>C', function()
  require('menus').menu(require('config.menus').git_compare_what)
end, { desc = 'Compare (git)' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('menus').menu(require('config.menus').git_menu, 'Git')
end, { desc = '[c]ommands' })
