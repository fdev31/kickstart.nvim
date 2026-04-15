-- vim:ts=2:sw=2:et:
-- SCHEDULE: decorative TODO/NOTE highlighting in comments
vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/folke/todo-comments.nvim',
  })

  require('todo-comments').setup({ signs = false })
end)
