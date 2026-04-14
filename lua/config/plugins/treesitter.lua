-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

local init = function()
  local ensureInstalled = settings.treesitter_languages
  local alreadyInstalled = require('nvim-treesitter').get_installed()
  local parsersToInstall = vim
    .iter(ensureInstalled)
    :filter(function(parser)
      return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()
  require('nvim-treesitter').install(parsersToInstall)
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Enable treesitter highlighting and disable regex syntax
    pcall(vim.treesitter.start)
    -- Enable treesitter-based indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    init()
  end,
})

vim.keymap.set('n', '<CR>', 'van', { remap = true, desc = 'Start incremental selection' })
vim.keymap.set('v', '<CR>', 'an', { remap = true, desc = 'Expand selection to parent node' })
vim.keymap.set('v', '<S-CR>', 'in', { remap = true, desc = 'Shrink selection to child node' })
vim.keymap.set('v', '<Tab>', ']n', { remap = true, desc = 'Select next sibling node' })
vim.keymap.set('v', '<S-Tab>', '[n', { remap = true, desc = 'Select previous sibling node' })

return {}
