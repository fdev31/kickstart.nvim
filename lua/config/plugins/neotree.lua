-- vim:ts=2:sw=2:et:
-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    event = 'VeryLazy',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<C-n>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      log_level = 'error',
      filesystem = {
        window = {
          mappings = {
            ['<C-n>'] = 'close_window',
            ['<leader>+'] = 'git_add_file',
            ['<leader>-'] = 'git_unstage_file',
            ['p'] = {
              'toggle_preview',
              config = {
                use_float = false,
                -- use_image_nvim = true,
                -- title = 'Neo-tree Preview',
              },
            },
          },
        },
      },
    },
  },
}
