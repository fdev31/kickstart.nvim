return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  'onsails/lspkind.nvim',
  {
    'folke/snacks.nvim', -- QoL (images, keymaps, ...)
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
    'dgagn/diagflow.nvim', -- diagnostics in virtual text
    event = 'LspAttach', -- This is what I use personally and it works great
    opts = {
      enable = true,
      scope = 'line', -- or cursor
      -- placement = 'inline',
      -- inline_padding_left = 3,
      show_borders = false,
      show_sign = false,
      toggle_event = { 'InsertEnter', 'InsertLeave' },
      update_event = { 'DiagnosticChanged', 'BufReadPost' }, -- the event that updates the diagnostics cache
      render_event = { 'DiagnosticChanged', 'CursorMoved', 'InsertLeave' },
      format = function(diagnostic)
        local origin = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.source or ''
        local prefix = ''
        if origin == 'Harper' then
          prefix = '  '
          origin = ''
        else
          if diagnostic.code then
            origin = origin .. ':' .. diagnostic.code
          end
          origin = string.format(' [%s]', origin)
        end

        return string.format('%s%s%s', prefix, diagnostic.message, origin)
      end,
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
