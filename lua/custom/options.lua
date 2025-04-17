local lib = require 'custom.lib'

local formatter = require('conform').formatters_by_ft

formatter['*'] = { 'codespell', 'trim_whitespace' }
formatter.go = { 'gofmt' }
formatter.lua = { 'stylua' }
formatter.rust = { 'rustfmt' }
formatter.toml = { 'toml_fmt' }
formatter.python = { 'ruff_format' }
formatter.javascript = { 'eslint_d', 'prettierd' }

vim.api.nvim_create_user_command('Chdir', 'cd %:h', {})

-- styling {{{
local no_background = { ctermbg = nil, guibg = nil, bg = nil }

local sideColor = '#282a36'

local hover_color = {
  bg = '#582a36',
}

local changed_color_dark = '#003300'

vim.api.nvim_set_hl(0, 'LspReferenceText', hover_color)
vim.api.nvim_set_hl(0, 'LspReferenceWrite', hover_color)
vim.api.nvim_set_hl(0, 'LspReferenceRead', hover_color)
vim.api.nvim_set_hl(0, 'LspReferenceTarget', { fg = '#aa45ff' })

vim.api.nvim_set_hl(0, 'DiffChange', { italic = true, bold = true, underline = true })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = changed_color_dark })
vim.api.nvim_set_hl(0, 'DiffText', { bold = true, bg = '#ddffee', fg = changed_color_dark })
vim.api.nvim_set_hl(0, 'NormalFloat', no_background)
vim.api.nvim_set_hl(0, 'TabLineFill', no_background)
vim.api.nvim_set_hl(0, 'StatusLine', no_background)
vim.api.nvim_set_hl(0, 'TelescopeNormal', vim.tbl_deep_extend('force', { fg = '#d8d8f2' }, no_background))
-- vim.api.nvim_set_hl(0, 'Normal', no_background)
-- vim.api.nvim_set_hl(0, 'FloatBorder', no_background)
--
-- vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = '#21222c' })
--
-- vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { bg = 'NONE', fg = '#888888' })
-- vim.api.nvim_set_hl(0, 'SignColumn', { bg = sideColor })
--
-- vim.api.nvim_set_hl(0, 'DiagnosticHint', { bg = sideColor, fg = '#d4b200' })
-- vim.api.nvim_set_hl(0, 'DiagnosticError', { bg = sideColor, fg = '#d40000' })
--
vim.api.nvim_set_hl(0, 'Cursor', { fg = '#000000', bg = '#FFaa33' })
vim.api.nvim_set_hl(0, 'Cursor2', { fg = '#000000', bg = '#FF0066' })
-- }}}

-- neovide / background-color {{{
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
-- }}}
--
-- Options {{{
local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window {{{
autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd =',
}) --- }}}
-- Hooks by File types {{{
local function set_spell()
  vim.opt_local.spell = true
  vim.opt_local.spelllang = 'en_us'
end

for _, ext in ipairs { 'rst', 'md', 'txt' } do
  autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.' .. ext,
    callback = set_spell,
  })
end

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'COMMIT_EDITMSG',
  callback = set_spell,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'mymenu_commands',
  callback = function()
    set_spell()
    vim.bo.filetype = 'menucommand'
  end,
})

autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.wiki',
  callback = function()
    set_spell()
    vim.bo.filetype = 'confluence_wiki'
    vim.bo.makeprg = 'br updes %'
  end,
})
autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
-- }}}
-- }}}

require('nvim-treesitter.configs').setup { -- {{{
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
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.confluence_wiki = {
  install_info = {
    url = 'https://github.com/fdev31/tree-sitter-confluence',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'confluence_wiki', -- if you want to set the filetype automatically
}

-- }}}

-- Hyprlang syntax & LSP {{{
-- LspInstall hyprlang
-- go install github.com/hyprland-community/hyprls/cmd/hyprls@latest
vim.filetype.add {
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
}
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function(event)
    vim.lsp.start {
      name = 'hyprlang',
      cmd = { 'hyprls' },
      root_dir = vim.fn.getcwd(),
    }
  end,
})
-- }}}
