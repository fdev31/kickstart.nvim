local map = vim.keymap.set
-- local nomap = vim.keymap.del
local lib = require 'custom.lib'

map('n', '<leader>s', function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = 'Toggle diagno[S]tics' })

map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffers' })

map('n', '<leader>m', require('treesj').toggle, { desc = 'Toggle [M]ultiline' })

map('n', '<leader>n', '<cmd> set rnu! <CR>', { noremap = true, silent = true, desc = 'Toggle relative [N]umber' })

map('n', '<C-,>', function()
  require('telescope').extensions.aerial.aerial()
end, { noremap = true, silent = true, desc = 'Toggle code outline window' })

-- dap
map('n', '<leader>i', function()
  require('dapui').toggle()
end, { noremap = true, silent = true, desc = 'Toggle debugger UI' })

map('n', '<leader>b', function()
  require('dap').toggle_breakpoint()
end, { noremap = true, silent = true, desc = 'Toggle debugger [b]reakpoint' })

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

map('n', '<leader>gb', function()
  package.loaded.gitsigns.blame_line()
end, { desc = '[G]it [B]lame Line' })

-- Navigation

-- vim diff

if lib.isGitMergetool then
  map('n', 'dr', '<cmd>diffget REMOTE<CR>', { noremap = true, silent = true, desc = 'Merge get remote' })
  map('n', 'dl', '<cmd>diffget LOCAL<CR>', { noremap = true, silent = true, desc = 'Merge get local' })
end

-- codeium

if not lib.isWorkLaptop then
  map('i', '<C-g>', function()
    return vim.fn['codeium#Accept']()
  end, { noremap = true, silent = true, expr = true, desc = 'Codeium Validate completion' })

  map('i', '<C-b>', function()
    return vim.fn['codeium#Complete']()
  end, { noremap = true, silent = true, expr = true, desc = 'Codeium Complete' })

  map('i', '<C-;>', function()
    return vim.fn['codeium#CycleCompletions'](1)
  end, { noremap = true, silent = true, expr = true, desc = 'Codeium Switch to next completion' })

  map('i', '<C-,>', function()
    return vim.fn['codeium#CycleCompletions'](-1)
  end, { noremap = true, silent = true, expr = true, desc = 'Codeium Switch to previous completion' })
end
