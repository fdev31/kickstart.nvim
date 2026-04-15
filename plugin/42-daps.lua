-- vim:ts=2:sw=2:et:
-- ON_FT: debug adapters (python, javascript, sh)
local _stb_ip = nil
local function get_stb_ip()
  if _stb_ip then return _stb_ip end
  local file = io.open(os.getenv('HOME') .. '/.onemw/config', 'r')
  if not file then return nil end
  for line in file:lines() do
    local key, value = line:match('^(STB_IP)=(.*)$')
    if key and value then
      file:close()
      _stb_ip = value
      return value
    end
  end
  file:close()
  return nil
end

local _dap_loaded = false
function _G.ensure_dap_loaded()
  if _dap_loaded then return end
  _dap_loaded = true

  vim.pack.add({
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/theHamsta/nvim-dap-virtual-text',
    'https://github.com/nvim-telescope/telescope-dap.nvim',
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/mfussenegger/nvim-dap-python',
    'https://github.com/rcarriga/nvim-dap-ui',
  })

  pcall(function() require('telescope').load_extension('dap') end)

  local dap = require('dap')
  vim.fn.sign_define('DapBreakpoint', { text = '🚩', texthl = '', linehl = '', numhl = '' })
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

  dap.defaults.fallback.force_external_terminal = true
  dap.defaults.fallback.external_terminal = {
    command = '/usr/bin/kitty',
  }

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = {
        vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
        '${port}',
      },
    },
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'pwa-node',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      console = 'integratedTerminal',
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
    {
      name = 'Attach to process',
      type = 'pwa-node',
      request = 'attach',
      processId = require('dap.utils').pick_process,
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
    {
      name = 'Attach to AS',
      type = 'pwa-node',
      request = 'attach',
      address = get_stb_ip(),
      port = 9230,
      remoteRoot = '/usr/share/lgias/app/',
      cwd = '${workspaceFolder}',
      localRoot = '${workspaceFolder}',
      skipFiles = { '<node_internals>/**' },
      stopOnEntry = true,
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
    {
      name = 'Attach to JSAPP',
      type = 'pwa-node',
      request = 'attach',
      address = get_stb_ip(),
      port = 9229,
      remoteRoot = '/usr/share/lgioui/app/',
      cwd = '${workspaceFolder}',
      localRoot = '${workspaceFolder}',
      skipFiles = { '<node_internals>/**' },
      stopOnEntry = true,
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
  }
  dap.configurations.typescript = dap.configurations.javascript
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
      pathBashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
      pathBashdbLib = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
    },
  }

  require('dap-python').setup()

  require('dapui').setup({
    controls = {
      element = 'repl',
      enabled = true,
      icons = {
        disconnect = '', pause = '', play = '', run_last = '󰑓',
        step_back = '', step_into = '', step_out = '',
        step_over = '', terminate = '',
      },
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = 'single',
      mappings = { close = { 'q', '<Esc>' } },
    },
    force_buffers = true,
    icons = { collapsed = '', current_frame = '', expanded = '' },
    layouts = {
      {
        elements = {
          { id = 'scopes', size = 0.25 },
          { id = 'breakpoints', size = 0.25 },
          { id = 'stacks', size = 0.25 },
          { id = 'watches', size = 0.25 },
        },
        position = 'left',
        size = 40,
      },
      {
        elements = { { id = 'repl', size = 1 } },
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
    render = { indent = 1, max_value_lines = 100 },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'sh' },
  once = true,
  callback = _G.ensure_dap_loaded,
})
