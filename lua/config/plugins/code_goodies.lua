-- vim:ts=2:sw=2:et:
return {
  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  { 'onsails/lspkind.nvim', event = 'VeryLazy' }, -- vscode-like pictograms
  {
    'folke/flash.nvim', -- improve t/f navigation
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      multi_window = false,
      wrap = false,
      incremental = true,
      modes = {
        search = {
          enabled = false,
        },
        char = {
          jump_labels = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  {
    'stevearc/aerial.nvim', -- navigate code symbols
    event = 'VeryLazy',
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
    event = 'VeryLazy',
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
    event = 'VeryLazy',
    opts = { use_default_keymaps = false, max_join_length = 1000 },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
