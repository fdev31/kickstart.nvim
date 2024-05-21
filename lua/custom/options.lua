local mapKey = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

vim.g.vscode_snippets_path = '~/.config/Code/User/snippets/'

vim.opt.wmh = 0
vim.opt.guifont = 'Fira Code,Noto Color Emoji:h11:#e-subpixelantialias'
vim.opt.clipboard = 'unnamedplus'

vim.opt.sw = 4
vim.opt.ts = 4
vim.opt.et = true
vim.opt.fdm = 'marker'
vim.opt.autoread = true

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

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
    vim.bo.filetype = 'confluencewiki'
    vim.bo.makeprg = 'br updes %'
  end,
})
autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint()
  end,
})
-- }}}
--
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
