vim.bo.makeprg = 'br updes %'

-- Install the confluence_wiki treesitter parser if not already available
-- (parser URL is registered via User TSUpdate autocmd in plugin/46-filetypes.lua)
local ok = pcall(vim.treesitter.language.add, 'confluence_wiki')
if not ok then
  pcall(function()
    require('nvim-treesitter').install({ 'confluence_wiki' })
  end)
end
