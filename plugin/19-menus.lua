-- vim:ts=2:sw=2:et:
-- DEFERRED: custom menus
require('lazyload').on_vim_enter(function()
  vim.pack.add({
    'https://github.com/fdev31/menus.nvim',
  })
end)
