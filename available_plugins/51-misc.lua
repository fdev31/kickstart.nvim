-- vim:ts=2:sw=2:et:
-- ON_CMD: miscellaneous
require('lazyload').on_lazy_commands({
  'VimBeBetter',
}, function(opts)
  local lib = require 'config.lib.core'
  lib.add_package { 'https://github.com/szymonwilczek/vim-be-better' }
end)
