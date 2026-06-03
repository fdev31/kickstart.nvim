local popup_style = { border = 'rounded' }

local advanced_syntax_support = {
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
  'typescript',
  'tsx',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'vim',
}

local autoformat_opts = {
  formatters_by_ft = {
    ['*'] = { 'codespell', 'trim_whitespace' },
    go = { 'gofmt' },
    lua = { 'stylua' },
    sh = { 'shfmt' },
    rust = { 'rustfmt' },
    cpp = { 'clang_format' },
    python = { 'ruff_fix', 'ruff_format' },
    javascript = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    vue = { 'prettierd' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    markdown = { 'prettierd' },
    http = { 'kulala' },
  },
  formatters = {
    kulala = {
      command = 'kulala-fmt',
      args = { 'format', '$FILENAME' },
      stdin = false,
    },
  },
}

local diagnostic_signs = {
  text = {
    [vim.diagnostic.severity.ERROR] = '󰅚',
    [vim.diagnostic.severity.WARN] = '󰀪',
    [vim.diagnostic.severity.INFO] = '󰋽',
    [vim.diagnostic.severity.HINT] = '󰌶',
  },
}

return {
  leader = '²',
  deduplicate_diagnostics = true,
  diff_command = 'DiffviewOpen -uno',
  gitsigns = {
    add = { text = '▋' },
  },
  popup_style = popup_style, -- style to apply to popups

  -- folder with wiki markdown files
  wiki_folder = vim.fn.expand '~/Documents/wiki/myKB',

  -- supported languages
  treesitter_languages = advanced_syntax_support,
  -- AI stuff
  copilot_chat = 'copilot', -- "codecompanion" or "copilot"
  -- completion settings
  cmp_sources = { 'lsp', 'path', 'buffer', 'snippets', 'lazydev' },
  cmp_providers = {
    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
  },
  -- diagnostic column settings
  diagnostic_config = {
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = false,
    signs = diagnostic_signs,
    update_in_insert = false,
    float = vim.tbl_deep_extend('force', {
      show_header = false,
      update_in_insert = false,
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
  -- (auto) formatting
  conform_opts = autoformat_opts,
  -- dynamic settings (togglable)
  showDiagnostics = true,

  -- Python LSP selection (startup-time; override in project-local .nvim.lua)
  --   'pylsp' | 'ty' | 'both'
  python_lsp = 'pylsp',

  -- Inlay hints: server-agnostic presets, applied via lua/config/lib/inlay_hints.lua
  -- The <leader>th keymap toggles rendering per buffer (see keymaps/lsp.lua).
  inlay_hints = {
    enabled_on_attach = false, -- off by default; toggle with <leader>th
    preset = 'full',           -- 'full' | 'lean' | 'off' | a table
    presets = {
      full = {
        parameter_names = 'all',
        parameter_types = true,
        variable_types  = true,
        return_types    = true,
        property_types  = true,
        enum_values     = true,
        extras          = true, -- server-specific goodies (await, BlockEnd, ...)
      },
      lean = {
        parameter_names = 'literals',
        enum_values     = true,
      },
      off = {},
    },
    -- Per-filetype override; value is a preset name or an inline table.
    -- e.g. by_filetype = { javascript = 'lean', lua = 'full' }
    by_filetype = {},
  },
}
