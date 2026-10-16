-- vim:ts=2:sw=2:et:
-- DEFERRED: diagnostic display handlers
require('lazyload').on_vim_enter(function()
  require('config.diagnostics').setup()
end)
