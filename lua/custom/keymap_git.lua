local partial = require('custom.lib').partial
local map = vim.keymap.set

local telescope = require 'telescope.builtin'

--------------------------------------------------
-- GIT OPERATIONS
--------------------------------------------------
map('n', '<leader>ga', '<cmd>G add %<CR>', { desc = '_add file (git)' })
map('n', '<leader>gr', '<cmd>G reset HEAD %<CR>', { desc = '_reset file (git)' })
map('n', '<leader>gc', '<cmd>DiffviewClose<CR><cmd>G commit %<CR>', { desc = '_commit file (git)' })
map('n', '<leader>gC', '<cmd>DiffviewClose<CR><cmd>G commit<CR>', { desc = '_Commit all (git)' })
map('n', '<leader>fc', telescope.git_status, { desc = '[c]hange (git)' })

-- Diffview and git operations
map('n', '<leader>D', function()
  if next(require('diffview.lib').views) == nil then
    vim.cmd 'DiffviewOpen -uno'
  else
    vim.cmd 'DiffviewClose'
  end
end, { desc = 'Diff view (toggle)' })

map('n', '<C-Space>', require('gitsigns').stage_hunk, { desc = 'stage/unstage hunk (git)' })
map('n', '<leader>C', function()
  require('menus').menu(require('custom.menus').git_compare_what)
end, { desc = 'Compare (git)' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('menus').menu(require('custom.menus').git_menu, 'Git')
end, { desc = '[c]ommands' })
