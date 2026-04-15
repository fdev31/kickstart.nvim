-- vim:ts=2:sw=2:et:
-- Treesitter: parser installation + highlighting/indentation
local settings = require('config.settings')

-- Build hook: update parsers on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.cmd('TSUpdate')
    end
  end,
})

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

-- Offer to install a parser for the current filetype if it's not in the curated list
local declined_parsers = {}

local no_parser_ft = { netrw = true, DiffviewFiles = true, DiffviewFileHistory = true }

local function offer_parser_install()
  local ft = vim.bo.filetype
  if ft == '' or vim.bo.buftype ~= '' or no_parser_ft[ft] then return end
  local lang = vim.treesitter.language.get_lang(ft) or ft
  if
    vim.tbl_contains(settings.treesitter_languages, lang)
    or declined_parsers[lang]
    or vim.tbl_contains(require('nvim-treesitter').get_installed(), lang)
  then
    return
  end
  vim.schedule(function()
    if vim.fn.confirm(("Install TreeSitter parser for '%s'?"):format(lang), '&Yes\n&No', 2) == 1 then
      require('nvim-treesitter').install({ lang })
    else
      declined_parsers[lang] = true
    end
  end)
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    ensure_parsers()
    offer_parser_install()
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
