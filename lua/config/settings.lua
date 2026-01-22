local ruff = require 'config.ruff_rules'

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
}

local gitsigns_icons = {
  text = {
    [vim.diagnostic.severity.ERROR] = '󰅚',
    [vim.diagnostic.severity.WARN] = '󰀪',
    [vim.diagnostic.severity.INFO] = '󰋽',
    [vim.diagnostic.severity.HINT] = '󰌶',
  },
}

local enabled_plugins = {
  'autocomplete',
  'autoformat',
  'code_goodies',
  'copilot',
  'daps',
  'diagnostics',
  'embedded',
  'filetypes',
  'git',
  'http_client',
  'lsp',
  'markdown',
  'menus',
  'misc',
  'neotree',
  'orgmode',
  'python',
  'qol',
  'silicon',
  'smooth_scroll',
  'theme',
  'treesitter',
  'whichkey',
  'workspaces',
  -- 'diffview',
}

return {
  leader = '²',
  deduplicate_diagnostics = true,
  diff_command = 'CodeDiff', -- 'Gvdiffsplit' or 'DiffviewOpen -uno' -- set by diffview plugin
  snapshots = 'silicon', -- codesnap or silicon
  gitsigns = {
    add = { text = '▋' }, -- ''
    -- change = { text = '' },
    -- delete = { text = '' },
    -- topdelete = { text = '' },
    -- changedelete = { text = '' },
  },
  popup_style = popup_style, -- style to apply to popups

  -- folder with wiki markdown files
  wiki_folder = vim.fn.expand '~/Documents/wiki/myKB',

  -- supported languages
  treesitter_languages = advanced_syntax_support,
  -- AI stuff
  copilotChat = 'copilot', -- "codecompanion" or "copilot"
  -- lazy plugin manager icons
  lazy_icons = {
    cmd = '⌘',
    config = '🛠',
    event = '📅',
    ft = '📂',
    init = '⚙',
    keys = ' ',
    plugin = '🔌',
    runtime = '💻',
    require = '🌙',
    source = '📄',
    start = '🚀',
    task = '📌',
    lazy = '💤 ',
  },
  -- completion settings
  cmp_dependencies = {},
  cmp_sources = { 'lsp', 'path', 'buffer', 'snippets', 'lazydev' },
  cmp_providers = {
    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
  },
  -- diagnostic column settings
  diagnostic_config = {
    underline = { severity = vim.diagnostic.severity.ERROR },
    virtual_text = false,
    signs = gitsigns_icons,
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
  plugins = enabled_plugins,
  -- python linting rules
  ruff_rules = ruff.rules,
  ruff_ignore = ruff.ignore,
  -- dynamic settings (togglable)
  showDiagnostics = true,
}
