-- vim:ts=2:sw=2:et:
local lib = require 'config.lib.core'

require('lazyload').on_lazy_commands({
  'OverseerRun',
  'OverseerToggle',
  'OverseerOpen',
}, function()
  lib.plugin { 'https://github.com/stevearc/overseer.nvim' }
  require('overseer').setup {}
end)
