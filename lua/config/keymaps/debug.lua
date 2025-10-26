local map = vim.keymap.set
--------------------------------------------------
-- DEBUGGING (DAP)
--------------------------------------------------

map('n', '<leader>dC', function() -- DAP configurations
  require('telescope').extensions.dap.configurations {}
end, { desc = 'DAP [C]onfigurations' })

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
