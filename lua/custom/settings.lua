local popup_style = { border = 'rounded' }
local ruff = require 'custom.ruff_rules'

-- select last "paste" with @s
vim.fn.setreg('s', "'[v']")

vim.g.mapleader = '²'
vim.g.maplocalleader = '²'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes:2'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = false

vim.g.conform_enabled = 'limited'
vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = 'getline(v:foldstart)'
vim.o.wmh = 0
vim.o.guifont = 'Fira Code,Noto Color Emoji:h11:#e-subpixelantialias'
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'

vim.o.sw = 4
vim.o.ts = 4
vim.o.et = true
-- vim.o.fdm = 'marker'
vim.o.foldmethod = 'manual'
vim.o.autoread = true
vim.o.number = false

vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = false

vim.o.foldenable = false
vim.o.termguicolors = true
vim.g.vscode_snippets_path = '~/.config/Code/User/snippets/'

vim.g.have_nerd_font = true
-- vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

-- delayed to save some startup time
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
-- local vue_language_server_path = '/path/to/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

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
