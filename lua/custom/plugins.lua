-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lib = require 'custom.lib'
local settings = require 'custom.settings'

M = {
  { 'fdev31/menus.nvim' },
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git', -- also try out "git_branch"
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    keys = {
      { '<leader>M', '<cmd>Grapple toggle<cr>', desc = 'Grapple' },
      { '<leader>m', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple [m]ove' },
      { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle [n]ext tag' },
      { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle [p]revious tag' },
    },
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'stevearc/overseer.nvim',
    opts = {},
  },
  { 'akinsho/org-bullets.nvim' }, -- bulletpoints in org mode
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      }
      require('org-bullets').setup()
    end,
  },
  {
    'folke/snacks.nvim', -- QoL (images, keymaps, ...)
    ---@type snacks.Config
    opts = {
      image = {},
      notifier = {},
    },
    priority = 1000,
  },
  {
    'karb94/neoscroll.nvim', -- animated scroll
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>',
        '<C-d>',
        '<C-b>',
        '<C-f>',
        '<C-y>',
        '<C-e>',
        'zt',
        'zz',
        'zb',
      },
      hide_cursor = true, -- Hide cursor while scrolling
      respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      duration_multiplier = 0.5, -- Global duration multiplier
      easing = 'sine', -- Default easing function
    },
  },
  {
    'jim-at-jibba/micropython.nvim',
    dependencies = { 'akinsho/toggleterm.nvim', 'stevearc/dressing.nvim' },
    config = function() end,
    ft = { 'python' },
    --[[
    keys = {
      {
        '<leader>mp',
        function()
          local mcp = require 'micropython_nvim'
          mcp.run()
        end,
      },
    },
    --]]
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      stay_on_this_version = true,
      -- Your options go here
      name = 'pyenv',
      auto_refresh = true,
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[v]env [s]elect' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = '[v]env [c]ache' },
    },
  },
  {
    'andymass/vim-matchup', -- nice language aware "%"
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      local mod = require 'match-up'
      mod.matchup_matchparen_offscreen = { method = 'popup' }
      mod.setup {}
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },
  {
    'nvim-telescope/telescope-dap.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'dap'
    end,
  },
  {
    'natecraddock/workspaces.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension 'workspaces'
      require('workspaces').setup {
        hooks = {
          open = { 'Telescope find_files' },
        },
      }
    end,
  },
  {
    'stevearc/dressing.nvim', -- better vim.ui (input, select, etc.)
    opts = {},
  },
  {
    'michaelrommel/nvim-silicon', -- nice code screenshots
    lazy = true,
    cmd = 'Silicon',
    opts = {
      --      disable_defaults = true,
      to_clipboard = true,
      output = '/tmp/code.png',
      --      background = '#212131',
      tab_width = 2,
      theme = 'gruvbox-dark',
      font = 'Fira Code',
      shadow_blur_radius = 7,
      pad_horiz = 30,
      pad_vert = 30,
      shadow_color = '#100000',
      background_image = '/home/fab/Images/code-bg.jpg',
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim', -- better markdown
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
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
    'sindrets/diffview.nvim', -- better diff view
    lazy = false,
    config = function()
      require('diffview').setup { -- {{{
        keymaps = {
          view = {
            {
              'n',
              'dl',
              require('diffview.actions').conflict_choose 'ours',
              { desc = 'Get left version (ours conflict)' },
            },
            {
              'n',
              'dr',
              require('diffview.actions').conflict_choose 'theirs',
              { desc = 'Get right version (theirs conflict)' },
            },
            {
              'n',
              'db',
              require('diffview.actions').conflict_choose 'base',
              { desc = 'Get original version (before conflict)' },
            },
          },
        },
        view = {
          merge_tool = {
            layout = 'diff4_mixed',
          },
        },
      } -- }}}
    end,
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
    opts = {},
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
      hlargs.setup()
      hlargs.enable()
    end,
  },
  {
    'Wansmer/treesj', -- merge / split lines
    keys = { '<leader>m' },
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {
        max_join_length = 300,
      }
    end,
  },
  { 'aklt/plantuml-syntax', ft = 'plantuml' },
  { 'NoahTheDuke/vim-just', ft = 'just' },
  { 'nvim-neotest/nvim-nio' },
  { -- DAPS
    'mfussenegger/nvim-dap',
    ft = { 'python', 'javascript', 'sh' },
    config = function()
      local dap = require 'dap'
      vim.fn.sign_define('DapBreakpoint', { text = '🚩', texthl = '', linehl = '', numhl = '' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      dap.defaults.fallback.force_external_terminal = true
      dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/kitty',
        -- args = { '-e' },
      }
      -- Adapters {{{
      dap.adapters['pwa-node'] = {
        type = 'server',
        port = 9229,
      }
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      } -- }}}
      -- Configurations {{{
      dap.configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        {
          type = 'pwa-node',
          request = 'attach local',
          skipFiles = { '<node_internals>/**' },
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        {
          name = 'Attach to JSAPP',
          type = 'pwa-node',
          protocol = 'inspector',
          mode = 'remote',
          skipFiles = { '<node_internals>/**' },
          request = 'attach',
          address = settings.stb_ip,
          port = 9229,
          remoteRoot = '/usr/share/lgioui/app/',
          cwd = '${workspaceFolder}',
          localRoot = '${workspaceFolder}',
          stopOnEntry = true,
        },
      }
      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file',
          showDebugOutput = true,
          trace = true,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          args = {},
          env = {},
          terminalKind = 'integrated',
          runInTerminal = false,
          pathCat = 'cat',
          pathBash = '/bin/bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        },
        --- }}}
      }
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'rcarriga/nvim-dap-ui' },
    ft = { 'python', 'javascript', 'sh' },
    config = function()
      require('dap-python').setup()
    end,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'javascript',
    config = function()
      require('dap-vscode-js').setup {
        debugger_path = '/home/fab/dev/microsoft/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    lazy = false,
    config = function()
      require('dapui').setup()
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    config = function() -- {{{
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      } -- }}}
    end,
  },
  { 'onsails/lspkind.nvim' },
}

if settings.useCopilot then
  lib.extend(settings.cmp_dependencies, {
    {
      'zbirenbaum/copilot-cmp',
      lazy = false,
      dependencies = {
        'hrsh7th/nvim-cmp',
        'zbirenbaum/copilot.lua',
        'onsails/lspkind.nvim',
      },
      config = function()
        require('copilot_cmp').setup()
      end,
    },
    {
      'zbirenbaum/copilot.lua',
      lazy = false,
      autostart = true,
      cmd = 'Copilot',
      event = 'InsertEnter',
      opts = {
        panel = { enabled = false },
        suggestion = {
          enabled = false,
          auto_trigger = false,
        },
        filetypes = {
          markdown = true,
          ['.'] = true,
        },
      },
    },
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      branch = 'main',
      lazy = false,
      dependencies = {
        { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
        { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
      },
      opts = {},
    },
  })
end

if settings.useCodeium then
  table.insert(settings.cmp_dependencies, {
    'Exafunction/codeium.nvim',
    cmd = 'Codeium',
    build = ':Codeium Auth',
    opts = {
      disable_bindings = true,
      enable_chat = true,
    },
  })
end

return M
