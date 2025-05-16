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
vim.o.foldmethod = 'syntax'
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

vim.diagnostic.config {
  float = popup_style,
}

local M = {
  useCopilot = true,
  popup_style = popup_style,
  stb_ip = get_stb_ip(),
  lsp_servers = {
    textlsp = {},
    harper_ls = {},
    dprint = {},
    typos_lsp = {},
    html = {},
    ruff = { enabled = false },
    pyright = { enabled = false },
    bashls = {},
    cssls = {},
    clangd = {},
    ccls = {},
    ts_ls = {},
    eslint = {},
    tailwindcss = {},
    pylsp = {
      settings = {
        pylsp = {
          plugins = {
            -- formatter options
            black = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            -- linter options
            pylint = { enabled = true },
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            pydocstyle = { enabled = false },
            pyright = { enabled = false },
            -- type checker
            pylsp_mypy = { enabled = true },
            -- auto-completion options
            jedi_completion = { fuzzy = true },
            -- import sorting
            pyls_isort = { enabled = false },
            -- ruff
            ruff = {
              enabled = false,
              formatEnabled = true,
            },
          },
        },
      },
    },
    volar = {
      filetypes = { 'vue', 'json' },
      init_options = {
        filetypes = { 'vue', 'json' },
        init_options = {
          typescript = {
            tsdk = '/usr/lib/node_modules/typescript/lib/',
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
  cmp_sources = { 'lsp', 'path', 'snippets', 'lazydev' },
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
