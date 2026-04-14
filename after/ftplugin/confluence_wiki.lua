vim.o.makeprg = 'br updes %'

-- Register the filetype-to-parser mapping (native Neovim 0.12 API)
vim.treesitter.language.register('confluence_wiki', 'confluence_wiki')

-- Install the parser if not already available
local ok = pcall(vim.treesitter.language.add, 'confluence_wiki')
if not ok then
  pcall(function()
    require('nvim-treesitter').install('confluence_wiki')
  end)
end
