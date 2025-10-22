-- vim:ts=2:sw=2:et:
return {
  {
    'fdev31/menus.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim', 'folke/snacks.nvim' },
  }, -- menus
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerOpen' },
  }, -- detect workspace's runnables, used in menus.lua
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          aerial = {
            highlight_on_hover = true,
            highlight_on_closest = true,
            autojump = true,
            show_guides = true,
            -- Display symbols as <root>.<parent>.<symbol>
            show_nesting = {
              ['_'] = true, -- This key will be the default
              python = true,
              js = true,
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
}
