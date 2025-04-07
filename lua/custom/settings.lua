-- read ~/.onemw/config and extract the value of STB_IP
--
--
local popup_style = { border = 'rounded' }

vim.opt.wmh = 0
vim.opt.guifont = 'Fira Code,Noto Color Emoji:h11:#e-subpixelantialias'
-- TODO: when every plugin supports it, uncomment the following
-- vim.opt.winborder = 'rounded'
vim.opt.clipboard = 'unnamedplus'

vim.opt.sw = 4
vim.opt.ts = 4
vim.opt.et = true
vim.opt.fdm = 'marker'
vim.opt.autoread = true
vim.opt.number = false

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

vim.opt.termguicolors = true
vim.g.vscode_snippets_path = '~/.config/Code/User/snippets/'

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
  useCodeium = true,
  popup_style = popup_style,
  border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  stb_ip = get_stb_ip(),
  lsp_servers = {
    textlsp = {},
    harper_ls = {},
    dprint = {},
    typos_lsp = {},
    html = {},
    ruff = {},
    pyright = {
      enabled = false,
    },
    bashls = {},
    cssls = {},
    clangd = {},
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
              enabled = true,
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
  cmp_sources = {
    {
      name = 'lazydev',
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },
    { group_index = 2, name = 'nvim_lsp' },
    { group_index = 2, name = 'luasnip' },
    { group_index = 2, name = 'path' },
    { group_index = 1, name = 'nvim_lsp_signature_help' },
    { group_index = 2, name = 'copilot' },
    { group_index = 2, name = 'codeium' },
  },
  lspconfig_dependencies = {},
  cmp_dependencies = {
    'onsails/lspkind.nvim',
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
