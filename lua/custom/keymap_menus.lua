-- :vim: foldlevel=0:
local map = vim.keymap.set
local telescope = require 'telescope.builtin'

--------------------------------------------------
-- MENUS
--------------------------------------------------
map({ 'n', 'v' }, 'gm', function()
  require('menus').menu(require('custom.menus').main_menu)
end, { desc = '[m]ain menu' })

-- Basic telescope searches
map('n', '<leader>fb', telescope.buffers, { desc = '[b]uffers' })
map('n', '<leader>fd', telescope.diagnostics, { desc = '[d]iagnostics' })
map('n', '<leader>ff', telescope.find_files, { desc = '[f]iles' })
map('n', '<leader>fF', telescope.git_files, { desc = '[F]iles (git)' })
map('n', '<leader>fG', telescope.live_grep, { desc = '[G]rep' })
map('n', '<leader>fg', package.loaded.snacks.picker.git_grep, { desc = '[g]rep (git)' })
map('n', '<leader>fh', telescope.help_tags, { desc = '[h]elp' })
map('n', '<leader>fi', package.loaded.snacks.picker.icons, { desc = '[i]cons' })
map('n', '<leader>fj', package.loaded.snacks.picker.jumps, { desc = '[j]umps' })
map('n', '<leader>fk', telescope.keymaps, { desc = '[k]eymaps' })
map('n', '<leader>fM', telescope.marks, { noremap = true, silent = true, desc = '[M]ark' })
map('n', '<leader>fr', telescope.lsp_references, { desc = '[r]eference' })
map('n', '<leader>fs', telescope.builtin, { desc = '[s]elect Telescope' })
map('n', '<leader>fw', telescope.grep_string, { desc = '[w]ord' })

-- Advanced search operations
map('n', '<C-CR>', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>f/', function()
  telescope.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[/] Open Files' })

map('n', '<leader>fn', function()
  package.loaded.snacks.picker.notifications()
end, { desc = '[n]otifications' })

-- Smart open and workspaces
map('n', '<leader><leader>', function()
  require('telescope').extensions.smart_open.smart_open()
end, { desc = 'Smart open' })

map('n', '<leader>~', function()
  require('telescope').extensions.smart_open.smart_open { cwd_only = true }
end, { desc = 'Smart open cwd' })

map('n', '<leader>ww', function()
  require('telescope').extensions.workspaces.workspaces()
end, { desc = '[w]alk [w]orkspaces' })

map('n', '<C-p>', function() -- pick symbol (aerial)
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })
