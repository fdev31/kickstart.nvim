-- vim:ts=2:sw=2:et:
-- Filetype detection (runs eagerly, but plugins are lazy)
vim.filetype.add({
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  extension = {
    wiki = 'confluence_wiki',
  },
})

-- Register custom treesitter parser for confluence_wiki (new nvim-treesitter main branch API)
-- Inject at startup so after/ftplugin/confluence_wiki.lua can trigger install immediately,
-- and via User TSUpdate autocmd so it persists across nvim-treesitter's internal reloads.
-- TSUpdate always rebuilds this parser from latest main (no pinned revision).
local confluence_wiki_parser = {
  install_info = {
    url = 'https://github.com/fdev31/tree-sitter-confluence',
    branch = 'main',
    queries = 'queries',
  },
}

local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
if ok then
  parsers.confluence_wiki = confluence_wiki_parser
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').confluence_wiki = confluence_wiki_parser
  end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function()
    vim.lsp.start({
      name = 'hyprlang',
      cmd = { vim.fn.stdpath('data') .. '/mason/packages/hyprls/hyprls' },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- Log highlight (deferred, not filetype-dependent)
require('lazyload').on_vim_enter(function()
  vim.pack.add({
    'https://github.com/fei6409/log-highlight.nvim',
  })
  require('log-highlight').setup({
    pattern = { 'xdev=.*' },
  })
end)

-- PlantUML
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'plantuml',
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/aklt/plantuml-syntax',
      'https://gitlab.com/itaranto/plantuml.nvim',
    })
    vim.opt_local.spell = false
    vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
    require('plantuml').setup({
      renderer = {
        type = 'imv',
        options = { dark_mode = false, format = nil },
      },
      render_on_write = true,
    })
  end,
})

-- Just
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'just',
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/NoahTheDuke/vim-just' })
  end,
})
