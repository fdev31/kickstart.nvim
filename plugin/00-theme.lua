-- vim:ts=2:sw=2:et:
-- EAGER: colorscheme must load before first paint
vim.pack.add({
  'https://github.com/Mofiqul/dracula.nvim',
})

local bg_color = '#100020'

require('dracula').setup({
  transparent_bg = not vim.g.neovide,
  italic_comment = true,
  colors = {
    bg = bg_color,
  },
})

vim.cmd.colorscheme('dracula')

if vim.g.neovide then
  vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = bg_color })
end

local no_background = { ctermbg = nil, guibg = nil, bg = nil }
local change_bg = '#154732'

vim.api.nvim_set_hl(0, 'Special', { fg = '#ffaaac' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = change_bg })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = change_bg })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#521414', fg = '#f29924' })
vim.api.nvim_set_hl(0, 'DiffText', { bold = true, bg = '#ddffee', fg = change_bg })
vim.api.nvim_set_hl(0, 'NormalFloat', no_background)
vim.api.nvim_set_hl(0, 'TabLineFill', no_background)
vim.api.nvim_set_hl(0, 'StatusLine', no_background)
vim.api.nvim_set_hl(0, 'TelescopeNormal', vim.tbl_deep_extend('force', { fg = '#d8d8f2' }, no_background))
vim.api.nvim_set_hl(0, 'Cursor', { fg = '#000000', bg = '#FFaa33' })
vim.api.nvim_set_hl(0, 'Cursor2', { fg = '#000000', bg = '#FF0066' })
vim.o.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50'

require('config.colors')
