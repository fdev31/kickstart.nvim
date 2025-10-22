-- vim:ts=2:sw=2:et:

vim.o.clipboard = 'unnamedplus'
vim.o.guifont = 'Fira Code,Noto Color Emoji:h11:#e-subpixelantialias'
vim.o.winborder = 'rounded'
vim.g.vscode_snippets_path = '~/.config/Code/User/snippets/'

-- Go to the file's folder with :Chdir
vim.api.nvim_create_user_command('Chdir', 'cd %:h', {})

-- Load custom snippets
require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/Code/User/snippets/' } }

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local autocmd = vim.api.nvim_create_autocmd
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- update layouts when resizing
autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd =',
})

if vim.g.neovide then
  local mapKey = vim.keymap.set
  mapKey('!', '<S-Insert>', '<C-R>+') -- allow Shit+Insert on the prompt

  vim.g.neovide_opacity = 0.90
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
