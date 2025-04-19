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

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.confluence_wiki = {
  install_info = {
    url = 'https://github.com/fdev31/tree-sitter-confluence',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'confluence_wiki', -- if you want to set the filetype automatically
}

-- fold method thinggie
autocmd({ 'FileType' }, {
  callback = function()
    if require('nvim-treesitter.parsers').has_parser() then
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      -- vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
    else
      vim.opt.foldmethod = 'syntax'
    end
  end,
})
