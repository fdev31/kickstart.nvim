local lib = require 'config.lib.core'
local settings = require 'config.settings'

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
  { 'windwp/nvim-ts-autotag', event = 'VeryLazy' },
  { 'windwp/nvim-autopairs', event = 'InsertEnter' },
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
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      max_lines = 1, -- Maximum number of lines to show for a single context
      multiwindow = false,
    },
  },
  { 'onsails/lspkind.nvim', event = 'VeryLazy' }, -- vscode-like pictograms
  {
    'folke/snacks.nvim', -- QoL (images, keymaps, ...)
    event = 'VeryLazy',
    ---@type snacks.Config
    opts = {
      image = {},
      notifier = {},
    },
    priority = 1000,
  },
  { 'theHamsta/nvim-dap-virtual-text', event = 'VeryLazy' },
  {
    'nvim-telescope/telescope-dap.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
  { 'stevearc/dressing.nvim', event = 'VeryLazy' }, -- better vim.ui (input, select, etc.)
  {
    'fei6409/log-highlight.nvim', -- better log files
    event = 'VeryLazy',
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
    event = 'VeryLazy',
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
    opts = {
      use_default_keymaps = false,
      max_join_length = 300,
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'klen/nvim-config-local',
    opts = {
      -- Config file patterns to load (lua supported)
      config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

      -- Where the plugin keeps files data
      hashfile = vim.fn.stdpath 'data' .. '/config-local',

      autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
      commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
      silent = false, -- Disable plugin messages (Config loaded/denied)
      lookup_parents = true, -- Lookup config files in parent directories
    },
  },
  'NMAC427/guess-indent.nvim',
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 100,
      win = settings.popup_style,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '↑ ',
          Down = '↓',
          Left = '← ',
          Right = '→ ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
        { '<leader>d', group = 'Debugging' },
        { '<leader>R', group = 'Request' },
        { '<leader>g', group = 'Git' },
        { '<leader>f', group = 'Find' },
        { '<leader>o', group = 'Org' },
        { '<leader>r', group = 'Run' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>h', group = 'Hunks (git)', mode = { 'n', 'v' } },
        { '<leader>v', group = 'Venv' },
        { '<leader>w', group = 'Workspaces' },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

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
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[f]or[m]at buffer',
      },
      {
        '<leader>tF',
        function()
          local enabled = vim.g.conform_enabled
          if enabled then
            vim.g.conform_enabled = false
          else
            vim.g.conform_enabled = 'limited'
          end
          vim.notify(vim.g.conform_enabled and 'Selective autoformat ' or 'No autoformat')
        end,
        mode = '',
        desc = '[f]ormat',
      },
      {
        '<leader>tf',
        function()
          local enabled = vim.g.conform_enabled
          if enabled == 'limited' then
            vim.g.conform_enabled = true
          else
            vim.g.conform_enabled = 'limited'
          end
          vim.notify(vim.g.conform_enabled == true and 'Full autoformat ' or 'Selective autoformat')
        end,
        mode = '',
        desc = '[f]ormat',
      },
    },
    opts = vim.tbl_deep_extend('force', settings.conform_opts, {
      notify_on_error = true,
      notify_no_formatters = true,
      format_on_save = function(bufnr)
        if vim.g.conform_enabled == false then
          return
        end
        if vim.g.conform_enabled == nil or vim.g.conform_enabled == 'limited' then
          if require 'config.lib.partial_formatter'() then
            return
          end
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {} --  c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
    }),
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    -- event = 'VimEnter',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = vim.list_extend({
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    }, settings.cmp_dependencies),
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'super-tab',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = settings.cmp_sources,
        providers = settings.cmp_providers,
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.align').setup {
        mappings = {
          start = '',
          start_with_preview = 'gA',
        },
      }
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
  },
}
-- :ts=2:sw=2:et:
