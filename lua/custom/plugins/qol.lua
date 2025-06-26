local lib = require 'custom.lib'

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  { 'windwp/nvim-ts-autotag' },
  { 'windwp/nvim-autopairs' },
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git_branch', -- also try out "git"
      icons = false,
      status = false,
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
      { '<leader>M', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
      -- { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
      -- { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
    },
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    config = function()
      require('marks').setup()
      vim.api.nvim_set_hl(0, 'MarkSignHL', { link = 'AerialLine' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      max_lines = 1, -- Maximum number of lines to show for a single context
      multiwindow = false,
    },
  },
  'onsails/lspkind.nvim',
  {
    'folke/snacks.nvim', -- QoL (images, keymaps, ...)
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = {},
      notifier = {},
    },
    priority = 1000,
  },
  'theHamsta/nvim-dap-virtual-text',
  {
    'nvim-telescope/telescope-dap.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
  'stevearc/dressing.nvim', -- better vim.ui (input, select, etc.)
  {
    'fei6409/log-highlight.nvim', -- better log files
    config = function()
      require('log-highlight').setup {
        pattern = {
          'xdev=.*',
        },
      }
    end,
  },
  {
    'danielfalk/smart-open.nvim', -- magic open "anything"
    branch = '0.2.x',
    lazy = false,
    config = function()
      require('telescope').load_extension 'smart_open'
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      'nvim-telescope/telescope.nvim',
      -- Only required if using match_algorithm fzf
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },
  {
    'norcalli/nvim-colorizer.lua', -- color preview
    config = function()
      require('colorizer').setup({ '*' }, {
        css = true,
        RRGGBBAA = true,
      })
    end,
  },
  {
    'stevearc/aerial.nvim', -- navigate code symbols
    lazy = false,
    config = function()
      require('aerial').setup {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Prev Aerial match' })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next Aerial match' })
        end,
      }
      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = '[a]erial' })
      require('telescope').load_extension 'aerial'
    end,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  { -- highlight args
    'm-demare/hlargs.nvim', -- make arguments a different color
    lazy = false,
    config = function()
      local hlargs = require 'hlargs'
      hlargs.setup {
        color = '#ffaa00',
      }
      hlargs.enable()
    end,
  },
  {
    'Wansmer/treesj', -- merge / split lines
    opts = {
      use_default_keymaps = false,
      max_join_length = 300,
    },
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
-- :ts=2:sw=2:et:
