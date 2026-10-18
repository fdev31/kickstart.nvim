-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: auto pairs

require('lazyload').on_insert_enter(function()
  local lib = require 'config.lib.core'
  lib.add_package {
    'https://github.com/windwp/nvim-autopairs',
  }

  require('nvim-autopairs').setup {}
end)
