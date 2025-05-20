-- :vim: foldlevel=0:
local partial = require('custom.lib').partial
local map = vim.keymap.set
local settings = require 'custom.settings'

local telescope = require 'telescope.builtin'

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
end, { buffer = bufnr, desc = 'vim.lsp.buf.hover()' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  -- code actions
  callback = function(event)
    local lspmap = function(keys, func, desc, mode)
      mode = mode or 'n'
      map(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    lspmap('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ctions', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    lspmap('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    lspmap('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    lspmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    lspmap('<leader>rn', vim.lsp.buf.rename, 'Re[n]ame')

    -- hover

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local highlight_supported = client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)

    if client and highlight_supported then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

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
--
map({ 'n', 'v' }, '<leader>cC', function()
  vim.cmd 'CopilotChat'
end, { desc = '[C]hat' })
map({ 'n', 'v' }, '<leader>ce', function()
  vim.cmd 'CopilotChatExplain'
end, { desc = '[e]xplain' })

map({ 'n', 'v' }, '<leader>co', function()
  vim.cmd 'CopilotChatOptimize'
end, { desc = '[o]ptimize' })

map({ 'n', 'v' }, '<leader>cd', function()
  vim.cmd 'CopilotChatOptimize'
end, { desc = '[d]ocument' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('menus').menu(require('custom.menus').main_menu)
end, { desc = '[c]ommands' })
