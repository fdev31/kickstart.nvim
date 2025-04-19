local settings = require 'custom.settings'
return {
  'nvim-neotest/nvim-nio',
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
}
