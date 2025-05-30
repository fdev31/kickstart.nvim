vim.filetype.add {
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  extension = {
    wiki = 'confluence_wiki',
  },
}
-- Hyprlang syntax & LSP
-- LspInstall hyprlang
-- go install github.com/hyprland-community/hyprls/cmd/hyprls@latest
--
local autocmd = vim.api.nvim_create_autocmd

autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function(event)
    vim.lsp.start {
      name = 'hyprlang',
      cmd = { 'hyprls' },
      root_dir = vim.fn.getcwd(),
    }
  end,
})

-- fold method thinggie
autocmd({ 'FileType' }, {
  callback = function()
    if require('nvim-treesitter.parsers').has_parser() then
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      -- vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
    else
      vim.o.foldmethod = 'syntax'
    end
  end,
})
