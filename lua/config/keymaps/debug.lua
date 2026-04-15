local map = vim.keymap.set
--------------------------------------------------
-- DEBUGGING (DAP)
--------------------------------------------------

map('n', '<leader>dC', function() -- DAP configurations
  _G.ensure_dap_loaded()
  require('telescope').extensions.dap.configurations {}
end, { desc = 'DAP [C]onfigurations' })

map('n', '<leader>ti', function()
  _G.ensure_dap_loaded()
  require('dapui').toggle()
end, { noremap = true, silent = true, desc = '[i]nspector' })

map('n', '<leader>db', function()
  _G.ensure_dap_loaded()
  require('dap').toggle_breakpoint()
end, { noremap = true, silent = true, desc = '[b]reakpoint' })

map('n', '<leader>dc', function()
  _G.ensure_dap_loaded()
  require('dap').continue()
end, { noremap = true, silent = true, desc = '[c]ontinue' })

map('n', '<leader>dn', function()
  _G.ensure_dap_loaded()
  require('dap').step_over()
end, { noremap = true, silent = true, desc = 'step [n]ext' })

map('n', '<leader>di', function()
  _G.ensure_dap_loaded()
  require('dap').step_into()
end, { noremap = true, silent = true, desc = 'step [i]nto' })

map('n', '<leader>do', function()
  _G.ensure_dap_loaded()
  require('dap').step_out()
end, { noremap = true, silent = true, desc = 'step [o]ut' })
