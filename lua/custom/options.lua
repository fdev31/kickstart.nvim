-- vim: foldlevel=0:
local lib = require 'custom.lib'

vim.api.nvim_create_user_command('Chdir', 'cd %:h', {})

-- Load custom snippets
require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/Code/User/snippets/' } }

-- formatter / linter options
--
local conform = require 'conform'

conform.formatters.toml_fmt = {
  command = 'toml_reformat',
  stdin = true,
}

local fmt_formatter = require('conform').formatters_by_ft
fmt_formatter['*'] = { 'codespell', 'trim_whitespace' }
fmt_formatter.go = { 'gofmt' }
fmt_formatter.lua = { 'stylua' }
fmt_formatter.rust = { 'rustfmt' }
fmt_formatter.toml = { 'toml_fmt' }
fmt_formatter.python = { 'ruff_format' }
fmt_formatter.javascript = { 'eslint_d', 'prettierd' }

-- style

local no_background = { ctermbg = nil, guibg = nil, bg = nil }
local sideColor = '#282a36'
local hover_color = {
  bg = '#2a3658',
}
local change_bg = '#154732' -- for diffview

vim.api.nvim_set_hl(0, 'Special', { fg = '#ffaaac' })

-- lsp auto hover
vim.api.nvim_set_hl(0, 'LspReferenceText', hover_color)
vim.api.nvim_set_hl(0, 'LspReferenceWrite', hover_color)
vim.api.nvim_set_hl(0, 'LspReferenceRead', hover_color)
-- diffview
vim.api.nvim_set_hl(0, 'DiffChange', { bg = change_bg })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = change_bg })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#521414', fg = '#521414' })
vim.api.nvim_set_hl(0, 'DiffText', { bold = true, bg = '#ddffee', fg = change_bg })
-- transparent backgrounds
vim.api.nvim_set_hl(0, 'NormalFloat', no_background)
vim.api.nvim_set_hl(0, 'TabLineFill', no_background)
vim.api.nvim_set_hl(0, 'StatusLine', no_background)
vim.api.nvim_set_hl(0, 'TelescopeNormal', vim.tbl_deep_extend('force', { fg = '#d8d8f2' }, no_background))
-- cursor
vim.api.nvim_set_hl(0, 'Cursor', { fg = '#000000', bg = '#FFaa33' })
vim.api.nvim_set_hl(0, 'Cursor2', { fg = '#000000', bg = '#FF0066' })
vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50'

if vim.g.neovide then
  local mapKey = vim.keymap.set
  mapKey('!', '<S-Insert>', '<C-R>+') -- allow Shit+Insert on the prompt

  vim.g.neovide_opacity = 0.85
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  -- vim.g.neovide_scale_factor = 0.8
  -- Dynamic Scale
  local _scaleChange = function(fac)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * fac
  end
  mapKey('n', '<C-=>', '', {
    silent = true,
    callback = function()
      _scaleChange(1.2)
    end,
  })
  mapKey('n', '<C-->', '', {
    silent = true,
    callback = function()
      _scaleChange(1 / 1.2)
    end,
  })
end

vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd =',
})

require('nvim-treesitter.configs').setup {
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
}
