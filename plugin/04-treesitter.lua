-- vim:ts=2:sw=2:et:
-- Treesitter: parser installation + highlighting/indentation
local settings = require('config.settings')

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

-- Install missing parsers (runs on each FileType, but is cheap when all are installed)
local function ensure_parsers()
  local ensureInstalled = settings.treesitter_languages
  local alreadyInstalled = require('nvim-treesitter').get_installed()
  local parsersToInstall = vim
    .iter(ensureInstalled)
    :filter(function(parser)
      return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()
  if #parsersToInstall > 0 then
    require('nvim-treesitter').install(parsersToInstall)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    ensure_parsers()
  end,
})

-- Incremental selection keymaps
vim.keymap.set('n', '<CR>', 'van', { remap = true, desc = 'Start incremental selection' })
vim.keymap.set('v', '<CR>', 'an', { remap = true, desc = 'Expand selection to parent node' })
vim.keymap.set('v', '<S-CR>', 'in', { remap = true, desc = 'Shrink selection to child node' })
vim.keymap.set('v', '<Tab>', ']n', { remap = true, desc = 'Select next sibling node' })
vim.keymap.set('v', '<S-Tab>', '[n', { remap = true, desc = 'Select previous sibling node' })
