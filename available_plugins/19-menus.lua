-- vim:ts=2:sw=2:et:
-- DEFERRED: custom menus
require('lazyload').on_vim_enter(function()
  local lib = require 'config.lib.core'
  lib.plugin {
    'https://github.com/fdev31/menus.nvim',
  }
end)
