-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

return {
  {
    'renerocksai/telekasten.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = 'Telekasten',
    opts = {
      home = settings.wiki_folder,
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim', -- better markdown
    ft = { 'markdown', 'codecompanion' },
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
  },
}
