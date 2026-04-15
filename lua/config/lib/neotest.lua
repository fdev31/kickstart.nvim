-- Re-entrant neotest setup: adapters can be registered from different
-- filetype plugins (python, javascript, etc.) and neotest is
-- (re)configured each time a new adapter is added.
local M = {}
local adapters = {}
local keymaps_set = false

local function setup_keymaps()
  if keymaps_set then return end
  keymaps_set = true

  local map = vim.keymap.set
  map('n', '<leader>Tt', function() require('neotest').run.run() end, { desc = 'Run neares[t] test' })
  map('n', '<leader>TT', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Run [T]est file' })
  map('n', '<leader>Ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle test [s]ummary' })
  map('n', '<leader>To', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle test [o]utput' })
  map('n', '<leader>Td', function() require('neotest').run.run({ strategy = 'dap' }) end, { desc = '[d]ebug nearest test' })
  map('n', '<leader>Tl', function() require('neotest').run.run_last() end, { desc = 'Run [l]ast test' })
end

--- Register a neotest adapter and (re)run setup.
--- @param adapter table  A neotest adapter instance (e.g. require('neotest-python')({...}))
function M.register(adapter)
  table.insert(adapters, adapter)
  require('neotest').setup({
    adapters = adapters,
  })
  setup_keymaps()
end

return M
