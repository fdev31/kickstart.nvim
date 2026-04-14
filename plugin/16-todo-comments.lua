-- vim:ts=2:sw=2:et:
-- SCHEDULE: decorative TODO/NOTE highlighting in comments
vim.schedule(function()
  -- plenary already added in 00-theme.lua, but vim.pack.add is idempotent
  vim.pack.add({
    'https://github.com/folke/todo-comments.nvim',
  })

  require('todo-comments').setup({ signs = false })
end)
