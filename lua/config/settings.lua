local popup_style = { border = 'rounded' }
local ruff = require 'config.ruff_rules'

return {
  leader = '²',
  diagnostic_config = {
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = false,
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or true,
    float = vim.tbl_deep_extend('force', {
      show_header = false,
      update_in_insert = true,
      focusable = false,
      scope = 'line',
      source = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    }, popup_style),

    severity_sort = true,
  },
  useCopilot = true,
  -- copilotChat = 'codecompanion',
  copilotChat = 'copilot',
  showDiagnostics = true,

  popup_style = popup_style,
  conform_opts = {
    formatters_by_ft = {
      ['*'] = { 'codespell', 'trim_whitespace' },
      go = { 'gofmt' },
      lua = { 'stylua' },
      sh = { 'shfmt' },
      rust = { 'rustfmt' },
      cpp = { 'clang_format' },
      toml = { 'toml_fmt' },
      python = { 'ruff_fix', 'ruff_format' },
      javascript = { 'prettierd' },
      http = { 'kulala' },
    },
    formatters = {
      toml_fmt = {
        command = 'toml_reformat',
        stdin = true,
      },
      kulala = {
        command = 'kulala-fmt',
        args = { 'format', '$FILENAME' },
        stdin = false,
      },
    },
  },
  treesitter_languages = {
    'bash',
    'diff',
    'toml',
    'vue',
    'c',
    'cpp',
    'css',
    'python',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'vim',
  },
  cmp_dependencies = {},
  cmp_sources = { 'lsp', 'path', 'buffer', 'snippets', 'lazydev' },
  cmp_providers = {
    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
  },
  ruff_rules = ruff.rules,
  ruff_ignore = ruff.ignore,
}
