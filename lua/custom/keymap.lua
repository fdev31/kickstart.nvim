local map = vim.keymap.set

map('n', '<leader>td', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.cmd 'DiagflowToggle'
  print 'plop'
end, { desc = '[T]oggle [d]iagnostics' })

map('n', '<leader>rr', function()
  vim.cmd 'OverseerRun'
end, { desc = '[R]un [R]unnable' })

map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [b]uffers' })

map('n', '<leader>fc', require('telescope.builtin').git_bcommits, { desc = '[F]ind GIT [c]hange' })

map('n', '<leader>tm', require('treesj').toggle, { desc = '[T]oggle [m]ultiline' })

map('n', '<leader>tn', '<cmd> set rnu! <CR>', { noremap = true, silent = true, desc = '[T]oggle relative [n]umber' })

map('n', '<leader>tN', '<cmd> set number! <CR>', { noremap = true, silent = true, desc = '[T]oggle line [N]umbering' })

map('n', '<C-,>', function()
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

map('n', '<leader>fM', function()
  require('telescope.builtin').marks()
end, { noremap = true, silent = true, desc = '[F]ind [M]ark' })

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
end, { noremap = true, silent = true, desc = '[T]oggle [i]nspector' })

map('n', '<leader>b', function()
  require('dap').toggle_breakpoint()
end, { noremap = true, silent = true, desc = 'Toggle debugger [b]reakpoint' })

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
end, { desc = '[C]opilot [E]xplain' })

map({ 'n', 'v' }, '<leader>co', function()
  vim.cmd 'CopilotChatOptimize'
end, { desc = '[C]opilot [O]ptimize' })

map({ 'n', 'v' }, '<leader>cc', function()
  require('telescope').extensions.custom_actions.custom_actions()
end, { desc = '[C]ustom [C]ommands' })

map('n', '<leader>ww', function()
  require('telescope').extensions.workspaces.workspaces()
end, { desc = '[W]alk [W]orkspaces' })

map('n', '<leader>ot', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('tabnew ' .. file)
end, { desc = 'Open file under cursor in new tab' })

map('n', '<leader>oo', function()
  local file = vim.fn.expand '<cfile>'
  vim.cmd('e ' .. file)
end, { desc = 'Open file under cursor in new tab' })

map('n', 'K', function()
  vim.lsp.buf.hover { border = 'rounded' }
end, { buffer = bufnr, desc = 'vim.lsp.buf.hover()' })
