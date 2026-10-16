-- vim:ts=2:sw=2:et:
-- ON_FT: debug adapters (python, javascript, sh)

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
    command = vim.fn.exepath('kitty'),
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
  }

  -- Load work-specific STB remote-attach configs if available
  pcall(function()
    local stb = require('config.dap_stb')
    vim.list_extend(dap.configurations.javascript, stb.configurations())
  end)

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
      pathBash = vim.fn.exepath('bash'),
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
