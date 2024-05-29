-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lib = require 'custom.lib'
local settings = require 'custom.settings'

M = {
  {
    'sindrets/diffview.nvim',
    lazy = false,
    config = function()
      require('diffview').setup {
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
      }
    end,
  },

  --[[ {
    'dgagn/diagflow.nvim',
    -- event = 'LspAttach', This is what I use personally and it works great
    opts = {
      enable = false,
      scope = 'line', -- or cursor
      placement = 'inline',
      inline_padding_left = 3,
      show_sign = true,
      update_event = { 'DiagnosticChanged', 'BufReadPost' }, -- the event that updates the diagnostics cache
      render_event = { 'DiagnosticChanged', 'CursorMoved' },
      show_borders = false,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
  }, ]]
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      vim.opt.termguicolors = true
      require('colorizer').setup({ '*' }, {
        css = true,
        RRGGBBAA = true,
      })
    end,
  },
  {
    'stevearc/aerial.nvim',
    lazy = false,
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  { -- highlight args
    'm-demare/hlargs.nvim',
    lazy = false,
    config = function()
      local hlargs = require 'hlargs'
      hlargs.setup()
      hlargs.enable()
    end,
  },
  { -- merge / split lines
    'Wansmer/treesj',
    keys = { '<leader>m' },
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {
        max_join_length = 300,
      }
    end,
  }, --}}}
  { 'aklt/plantuml-syntax', ft = 'plantuml' },
  { 'NoahTheDuke/vim-just', ft = 'just' },
  { 'vim-scripts/confluencewiki.vim', ft = 'confluencewiki' },
  { 'nvim-neotest/nvim-nio' },
  { -- DAPS
    'mfussenegger/nvim-dap',
    ft = { 'python', 'javascript', 'sh' },
    config = function()
      local dap = require 'dap'
      vim.fn.sign_define('DapBreakpoint', { text = '🚩', texthl = '', linehl = '', numhl = '' })

      dap.defaults.fallback.force_external_terminal = true
      dap.defaults.fallback.external_terminal = {
        command = '/usr/bin/kitty',
        args = { '-e' },
      }
      -- Adapters {{{
      dap.adapters['pwa-node'] = {
        type = 'server',
      }
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      } -- }}}
      -- Configurations {{{
      dap.configurations.javascript = {
        {
          name = 'Attach to process',
          type = 'pwa-node',
          request = 'attach',
          address = '192.168.100.42',
          cwd = '${workspaceFolder}',
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
    requires = { 'rcarriga/nvim-dap-ui' },
    ft = { 'python', 'javascript', 'sh' },
    config = function()
      require('dap-python').setup()
    end,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    requires = { 'mfussenegger/nvim-dap' },
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
    requires = { 'mfussenegger/nvim-dap' },
    lazy = false,
    config = function()
      require('dapui').setup()
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    config = function()
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
      }
    end,
  },
  { 'onsails/lspkind.nvim' },
}

if settings.useCopilot then
  lib.extend(settings.cmp_dependencies, {
    {
      'zbirenbaum/copilot-cmp',
      lazy = false,
      autostart = true,
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
      branch = 'canary',
      lazy = false,
      dependencies = {
        { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
        { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
      },
      opts = { debug = true },
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
