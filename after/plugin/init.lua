-- vim:ts=2:sw=2:et:
local apply_options = require 'config.options'
apply_options()
vim.schedule(function()
  require 'config.keymaps'
  require 'config.late_options'
  apply_options()
end)
