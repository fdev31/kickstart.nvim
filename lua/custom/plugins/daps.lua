local settings = require 'custom.settings'

-- read ~/.onemw/config and extract the value of STB_IP
local _stb_ip = nil
local function get_stb_ip()
  if _stb_ip then
    return _stb_ip
  end
  local file = io.open(os.getenv 'HOME' .. '/.onemw/config', 'r')
  if not file then
    return nil
  end
  for line in file:lines() do
    local key, value = line:match '^(STB_IP)=(.*)$'
    if key and value then
      file:close()
      _stb_ip = value
      return value
    end
  end
  file:close()
  return nil
end

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
      dap.adapters.node2 = {
        -- NOTE: requires cloning https://github.com/microsoft/vscode-node-debug2.git into ~/dev/microsoft
        type = 'executable',
        command = 'node',
        args = { os.getenv 'HOME' .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js' },
      }
      dap.configurations.javascript = {
        {
          name = 'Launch',
          type = 'node2',
          request = 'launch',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          -- For this to work you need to make sure the node process is started with the `--inspect` flag.
          name = 'Attach to process',
          type = 'node2',
          request = 'attach',
          processId = require('dap.utils').pick_process,
        },
        {
          name = 'Attach to AS',
          type = 'node2',
          protocol = 'inspector',
          mode = 'remote',
          skipFiles = { '<node_internals>/**' },
          request = 'attach',
          address = get_stb_ip(),
          port = 9230,
          remoteRoot = '/usr/share/lgias/app/',
          cwd = '${workspaceFolder}',
          localRoot = '${workspaceFolder}',
          stopOnEntry = true,
        },
        {
          name = 'Attach to JSAPP',
          type = 'node2',
          protocol = 'inspector',
          mode = 'remote',
          skipFiles = { '<node_internals>/**' },
          request = 'attach',
          address = get_stb_ip(),
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
    'mfussenegger/nvim-dap-python', -- requires to install debugpy
    dependencies = { 'rcarriga/nvim-dap' },
    ft = { 'python', 'javascript', 'sh' },
    config = function()
      require('dap-python').setup()
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    lazy = false,
    opts = {
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          disconnect = '',
          pause = '',
          play = '',
          run_last = '',
          step_back = '',
          step_into = '',
          step_out = '',
          step_over = '',
          terminate = '',
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = '',
        current_frame = '',
        expanded = '',
      },
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.25,
            },
            {
              id = 'breakpoints',
              size = 0.25,
            },
            {
              id = 'stacks',
              size = 0.25,
            },
            {
              id = 'watches',
              size = 0.25,
            },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = { {
            id = 'repl',
            size = 1,
          } },
          position = 'bottom',
          size = 10,
        },
      },
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
  },
}
