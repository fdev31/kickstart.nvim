-- vim:ts=2:sw=2:et:
-- SCHEDULE: diagnostic display handlers
vim.schedule(function()
  require('config.diagnostics').setup()
end)
