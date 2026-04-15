-- vim:ts=2:sw=2:et:
-- DEFERRED: decorative TODO/NOTE highlighting in comments
require('lazyload').on_vim_enter(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/folke/todo-comments.nvim',
  })

  require('todo-comments').setup({ signs = false })
end)
