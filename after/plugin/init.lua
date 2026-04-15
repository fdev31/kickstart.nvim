-- vim:ts=2:sw=2:et:
require('lazyload').on_vim_enter(function()
  require 'config.keymaps'
  require 'config.late_options'
end, { sync = true })
