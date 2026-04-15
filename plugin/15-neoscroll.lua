-- vim:ts=2:sw=2:et:
-- DEFERRED: smooth scrolling (remaps common motions)
require('lazyload').on_vim_enter(function()
  vim.pack.add({
    'https://github.com/karb94/neoscroll.nvim',
  })

  require('neoscroll').setup({
    mappings = {
      '<C-u>', '<C-d>', '<C-b>', '<C-f>',
      '<C-y>', '<C-e>', 'zt', 'zz', 'zb',
    },
    hide_cursor = false,
    respect_scrolloff = true,
    duration_multiplier = 0.5,
    easing = 'sine',
  })
end)
