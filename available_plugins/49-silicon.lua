-- vim:ts=2:sw=2:et:
require('lazyload').on_lazy_commands({ 'Silicon' }, function()
  local lib = require 'config.lib.core'
  lib.add_package {
    'https://github.com/michaelrommel/nvim-silicon',
  }
  require('nvim-silicon').setup {
    to_clipboard = true,
    output = '/tmp/code.png',
    tab_width = 2,
    theme = 'Dracula',
    font = 'Fira Code',
    shadow_blur_radius = 7,
    pad_horiz = 30,
    pad_vert = 30,
    shadow_color = '#100000',
  }
end)
