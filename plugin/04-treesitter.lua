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

-- Incremental selection keymaps (skip special buffers: help, quickfix, terminal, etc.)
vim.keymap.set('n', '<CR>', function()
  if vim.bo.buftype ~= '' then return '<CR>' end
  return 'van'
end, { remap = true, expr = true, desc = 'Start incremental selection' })

vim.keymap.set('v', '<CR>', function()
  if vim.bo.buftype ~= '' then return '<CR>' end
  return 'an'
end, { remap = true, expr = true, desc = 'Expand selection to parent node' })

vim.keymap.set('v', '<S-CR>', function()
  if vim.bo.buftype ~= '' then return '<S-CR>' end
  return 'in'
end, { remap = true, expr = true, desc = 'Shrink selection to child node' })

vim.keymap.set('v', '<Tab>', function()
  if vim.bo.buftype ~= '' then return '<Tab>' end
  return ']n'
end, { remap = true, expr = true, desc = 'Select next sibling node' })

vim.keymap.set('v', '<S-Tab>', function()
  if vim.bo.buftype ~= '' then return '<S-Tab>' end
  return '[n'
end, { remap = true, expr = true, desc = 'Select previous sibling node' })
