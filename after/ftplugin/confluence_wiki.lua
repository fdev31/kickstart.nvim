vim.o.makeprg = 'br updes %'

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.confluence_wiki = {
  install_info = {
    url = 'https://github.com/fdev31/tree-sitter-confluence',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'confluence_wiki', -- if you want to set the filetype automatically
}
