local map = vim.keymap.set

map('n', '<leader>Q', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.cmd 'DiagflowToggle'
end, { desc = 'Toggle diagno[Q]tics' })

map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })

map('n', '<leader>m', require('treesj').toggle, { desc = 'Toggle [M]ultiline' })

map('n', '<leader>n', '<cmd> set rnu! <CR>', { noremap = true, silent = true, desc = 'Toggle relative [N]umber' })

map('n', '<C-,>', function()
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

map('n', '<leader>fM', function()
  require('telescope.builtin').marks()
end, { noremap = true, silent = true, desc = '[F]ind [M]ark' })

local _dapVisible = false
-- dap
map('n', '<leader>i', function()
  if _dapVisible then
    require('dapui').close()
    _dapVisible = false
  else
    require('dapui').open()
    _dapVisible = true
    require('telescope').extensions.dap.configurations {}
  end
  -- require('dapui').toggle()
end, { noremap = true, silent = true, desc = 'Toggle debugger UI' })

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

-- gitsigns
--
map('n', '<leader>ga', function()
  package.loaded.gitsigns.stage_hunk()
end, { noremap = true, silent = true, desc = '[G]it [a]dd hunk' })

map('n', '<leader>gA', function()
  package.loaded.gitsigns.stage_buffer()
end, { noremap = true, silent = true, desc = '[G]it [A]dd buffer' })

map('n', '<leader>gu', function()
  package.loaded.gitsigns.undo_stage_hunk()
end, { noremap = true, silent = true, desc = '[G]it [u]ndo saged hunk' })

-- project / sessions

map('n', '<leader>p', function()
  vim.cmd 'Telescope neovim-project'
end, { desc = '[p]roject list' })

map('n', '<leader>P', function()
  vim.cmd 'Telescope neovim-project discover'
end, { desc = '[P]roject discover' })

map('n', '<C-,>', function()
  package.loaded.telescope.extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

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
