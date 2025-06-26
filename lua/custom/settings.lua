local popup_style = { border = 'rounded' }

-- custom file types

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

-- read ~/.onemw/config and extract the value of STB_IP
local function get_stb_ip()
  local file = io.open(os.getenv 'HOME' .. '/.onemw/config', 'r')
  if not file then
    return nil
  end
  for line in file:lines() do
    local key, value = line:match '^(STB_IP)=(.*)$'
    if key and value then
      file:close()
      return value
    end
  end
  file:close()
  return nil
end

local M = {
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
  copilotChat = 'codecompanion',
  showDiagnostics = true,

  popup_style = popup_style,
  stb_ip = get_stb_ip(),
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
      javascript = { 'eslint_d', 'prettierd' },
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
  treesitter_opts = {
    modules = { 'highlight', 'incremental_selection', 'folding', 'mashup' },
    sync_install = true,
    ignore_install = {},
    ensure_installed = {
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
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
      },
    },
  },
  lsp_servers = {
    textlsp = {},
    harper_ls = {
      ['harper-ls'] = {
        fileDictPath = '~/.config/nvim/spell/en.utf-8.add',
      },
    },
    dprint = {},
    typos_lsp = {},
    html = {},
    ruff = { enabled = true, formatEnabled = true },
    pylint = { enabled = false },
    pyright = { enabled = false },
    pycodestyle = { enabled = false }, -- in pylsp
    bashls = {},
    black = { enabled = false },
    cssls = {},
    clangd = {},
    -- ccls = {},
    ts_ls = {},
    pyflakes = { enabled = false },
    eslint = {},
    tailwindcss = {},
    mypy = { enabled = false },
    -- python_lsp_isort = {},
    pylsp = {
      -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
      settings = {
        pylsp = {
          signature_ = {
            formatter = 'ruff',
          },
          plugins = {
            -- formatter options
            autopep8 = { enabled = false },
            yapf = { enabled = true },
            -- linter options
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = true },
            pydocstyle = { enabled = true },
            -- type checker
            pylsp_mypy = { enabled = false },
            -- auto-completion options
            jedi_completion = { fuzzy = true },
            -- navigation-related plugins
            -- rope_completion = { enabled = true },
            -- rope_autoimport = { enabled = true },
            -- jedi_completion = { enabled = true },
            -- jedi_definition = { enabled = true },
            -- jedi_hover = { enabled = true },
            -- jedi_references = { enabled = true },
            -- jedi_signature_help = { enabled = true },
            jedi_symbols = { enabled = true },
          },
        },
      },
    },
    lua_ls = {
      -- cmd = { ... },
      -- filetypes = { ... },
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
  },
  telescope_extensions = {
    aerial = {
      highlight_on_hover = true,
      highlight_on_closest = true,
      autojump = true,
      show_guides = true,
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ['_'] = true, -- This key will be the default
        python = true,
        js = true,
      },
    },
  },
  lspconfig_dependencies = {},
  cmp_dependencies = {},
  cmp_sources = { 'lsp', 'path', 'buffer', 'snippets', 'lazydev' },
  cmp_providers = {
    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
  },
  ruff_rules = {
    'A',
    'AIR',
    'ANN',
    'ARG',
    'ASYNC',
    'B',
    'B',
    -- "BLE",
    'C',
    'C4',
    'C90',
    'D',
    'D',
    'DTZ',
    'E',
    'EM',
    'EXE',
    'F',
    'FA',
    -- "FBT",
    'FIX',
    'FLY',
    'G',
    'I',
    'ICN',
    'INP',
    'INT',
    'ISC',
    'LOG',
    'N',
    'PERF',
    'PIE',
    'PL',
    'PT',
    'PYI',
    'Q',
    'RET',
    'RSE',
    'S',
    'SIM',
    'SLF',
    'SLOT',
    'T10',
    'TCH',
    'TD',
    'TID',
    'ASYNC1',
    'TRY',
    'UP',
    'W',
    'YTT',
  },
  ruff_ignore = {
    'ANN002',
    'ANN003',
    'ANN101',
    'ANN102',
    'ANN204',
    'D105',
    'D107',
    'E203',
    'ISC001',
    'PLW0603',
    'PTH118',
    'RET503',
    'S101',
    'S311',
    'S404',
    'S602',
    'S603',
    'S605',
    'S607',
    'TID252',
  },
}
return M
