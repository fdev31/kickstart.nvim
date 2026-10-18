-- vim:ts=2:sw=2:et:
-- ON_CMD: PlatformIO
require('lazyload').on_lazy_commands({ 'Pioinit', 'Piorun', 'Piocmd', 'Piomon', 'Piodebug', 'Piolib' }, function()
  local lib = require 'config.lib.core'
  lib.plugin {
    'https://github.com/akinsho/nvim-toggleterm.lua',
    'https://github.com/anurag3301/nvim-platformio.lua',
  }
end)
