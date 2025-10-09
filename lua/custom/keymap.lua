-- :vim: foldlevel=0:
local partial = require('custom.lib').partial
local map = vim.keymap.set
local settings = require 'custom.settings'

local telescope = require 'telescope.builtin'

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<leader>ga', '<cmd>G add %<CR>', { desc = '_add file (git)' })
map('n', '<leader>gr', '<cmd>G reset HEAD %<CR>', { desc = '_reset file (git)' })
map('n', '<leader>gc', '<cmd>DiffviewClose<CR><cmd>G commit %<CR>', { desc = '_commit file (git)' })
map('n', '<leader>gC', '<cmd>DiffviewClose<CR><cmd>G commit<CR>', { desc = '_Commit all (git)' })
map('n', 'gd', require('custom.lib').openUnder, { desc = '_Definition (can open file under cursor)' })

-- basic operations
map('n', '<leader>tm', require('treesj').toggle, { desc = '[m]ultiline' })
map('n', '<leader>tn', '<cmd> set nonumber rnu! <CR>', { noremap = true, silent = true, desc = '[n]umber relative' })
map('n', '<leader>tN', '<cmd> set number! nornu <CR>', { noremap = true, silent = true, desc = '[N]umbering' })
map('n', '<leader>oo', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('tabnew ' .. file)
end, { desc = '[o]pen file under cursor' })
map('n', 'K', function()
  vim.lsp.buf.hover()
end, { buffer = bufnr, desc = 'LSP symbol doc' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- find stuff / telescope & co
map('n', '<leader>fb', telescope.buffers, { desc = '[b]uffers' })
map('n', '<leader>fc', telescope.git_status, { desc = '[c]hange (git)' })
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

-- Slightly advanced example of overriding default behavior and theme
map('n', '<C-CR>', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
map('n', '<leader>f/', function()
  telescope.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[/] Open Files' })

-- Shortcut for searching your Neovim notifications
map('n', '<leader>fn', function()
  package.loaded.snacks.picker.notifications()
end, { desc = '[n]otifications' })

-- workspaces
map('n', '<leader>ww', function()
  require('telescope').extensions.workspaces.workspaces()
end, { desc = '[w]alk [w]orkspaces' })

-- smart open
map('n', '<leader><leader>', function()
  require('telescope').extensions.smart_open.smart_open()
end, { desc = 'Smart open' })

map('n', '<leader>~', function()
  require('telescope').extensions.smart_open.smart_open { cwd_only = true }
end, { desc = 'Smart open cwd' })

map('n', '<C-p>', function() -- pick symbol (aerial)
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

map('n', '<leader>dC', function() -- DAP configurations
  require('telescope').extensions.dap.configurations {}
end, { desc = 'DAP [C]onfigurations' })

-- diff & git things
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

-- toggle diagnostics
map('n', '<leader>td', function()
  settings.showDiagnostics = not settings.showDiagnostics

  vim.diagnostic.enable(settings.showDiagnostics)

  if not settings.showDiagnostics and settings._diag_window then
    vim.api.nvim_win_close(settings._diag_window, true)
  end
  vim.o.spell = settings.showDiagnostics
end, { desc = '[d]iagnostics' })

-- dap
map('n', '<leader>ti', require('dapui').toggle, { noremap = true, silent = true, desc = '[i]nspector' })

map('n', '<leader>db', function()
  require('dap').toggle_breakpoint()
end, { noremap = true, silent = true, desc = '[b]reakpoint' })

map('n', '<leader>dc', function()
  require('dap').continue()
end, { noremap = true, silent = true, desc = '[c]continue' })

map('n', '<leader>dn', function()
  require('dap').step_over()
end, { noremap = true, silent = true, desc = 'step [n]next' })

map('n', '<leader>di', function()
  require('dap').step_into()
end, { noremap = true, silent = true, desc = 'step [i]nto' })

map('n', '<leader>do', function()
  require('dap').step_out()
end, { noremap = true, silent = true, desc = 'step [o]ut' })

-- copilot

map({ 'n', 'v' }, '<leader>cp', function()
  if settings.copilotChat == 'codecompanion' then
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == '\22' then
      vim.cmd "'<,'>CodeCompanion"
    else
      vim.cmd 'CodeCompanion'
    end
  end
end, { desc = '[p]rompt (AI)' })
map({ 'n', 'v' }, '<leader>cC', function()
  if settings.copilotChat == 'codecompanion' then
    vim.cmd('CodeCompanionChat', 'Toggle')
  else
    vim.cmd 'CopilotChat'
  end
end, { desc = '[C]hat (AI)' })

map({ 'n', 'v' }, '<leader>co', function()
  if settings.copilotChat == 'codecompanion' then
    vim.cmd 'CodeCompanionActions'
  else
    vim.cmd 'CopilotChatOptimize'
  end
end, { desc = 'AI [O]ptions' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('menus').menu(require('custom.menus').git_menu, 'Git')
end, { desc = '[c]ommands' })

map({ 'n', 'v' }, 'gm', function()
  require('menus').menu(require('custom.menus').main_menu)
end, { desc = '[c]ommands' })
