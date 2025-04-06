local map = vim.keymap.set

map('n', '<leader>td', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.cmd 'DiagflowToggle'
  print 'plop'
end, { desc = '[d]iagnostics' })

map('n', '<leader>rr', function()
  vim.cmd 'OverseerRun'
end, { desc = '[r]unnable' })

map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[b]uffers' })

map('n', '<leader>fc', require('telescope.builtin').git_bcommits, { desc = '[c]hange (git)' })

map('n', '<C-Space>', require('gitsigns').stage_hunk, { desc = 'stage/unstage hunk (git)' })
map('n', '<leader>C', function()
  vim.cmd 'Compare'
end, { desc = '[C]ompare (git)' })

map('n', '<leader>tm', require('treesj').toggle, { desc = '[m]ultiline' })

map('n', '<leader>tn', '<cmd> set rnu! <CR>', { noremap = true, silent = true, desc = '[n]umber relative' })

map('n', '<leader>tN', '<cmd> set number! <CR>', { noremap = true, silent = true, desc = '[N]umbering' })

map('n', '<C-,>', function()
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

map('n', '<leader>fM', function()
  require('telescope.builtin').marks()
end, { noremap = true, silent = true, desc = '[M]ark' })

local _dapVisible = false
-- dap
map('n', '<leader>ti', function()
  if _dapVisible then
    require('dapui').close()
    _dapVisible = false
  else
    require('dapui').open()
    _dapVisible = true
    require('telescope').extensions.dap.configurations {}
  end
end, { noremap = true, silent = true, desc = '[i]nspector' })

map('n', '<leader>tb', function()
  require('dap').toggle_breakpoint()
end, { noremap = true, silent = true, desc = 'Debugger [b]reakpoint' })

map('n', '<F5>', function()
  require('dap').continue()
end)
map('n', '<F10>', function()
  require('dap').step_over()
end)
map('n', '<F11>', function()
  require('dap').step_into()
end)
map('n', '<F12>', function()
  require('dap').step_out()
end)

map('n', '<leader><leader>', function()
  require('telescope').extensions.smart_open.smart_open()
end, { desc = 'Smart open' })

map({ 'n', 'v' }, '<leader>ce', function()
  vim.cmd 'CopilotChatExplain'
end, { desc = '[e]xplain' })

map({ 'n', 'v' }, '<leader>co', function()
  vim.cmd 'CopilotChatOptimize'
end, { desc = '[o]ptimize' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('telescope').extensions.custom_actions.custom_actions()
end, { desc = '[c]ommands' })

map('n', '<leader>ww', function()
  require('telescope').extensions.workspaces.workspaces()
end, { desc = '[w]alk [w]orkspaces' })

map('n', '<leader>ot', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('tabnew ' .. file)
end, { desc = 'Open file under cursor in new [t]ab' })

map('n', '<leader>oo', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('e ' .. file)
end, { desc = '[o]pen file under cursor' })

map('n', 'K', function()
  vim.lsp.buf.hover { border = 'rounded' }
end, { buffer = bufnr, desc = 'vim.lsp.buf.hover()' })
