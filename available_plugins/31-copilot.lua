-- vim:ts=2:sw=2:et:
require('lazyload').on_vim_enter( function()
  local settings = require 'config.settings'
  if settings.ai_chat then
    require('config.code_assist.' .. settings.ai_chat).assistant()
  end
  if settings.ai_completion then
    require('config.code_assist.' .. settings.ai_completion).completion()
  end
end)
