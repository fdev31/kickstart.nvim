-- vim:ts=2:sw=2:et:
vim.api.nvim_create_autocmd('VimEnter', {
  once=True,
  callback = function()
    local settings = require 'config.settings'
    if settings.ai_chat then
      require('plugin.code_assist.' .. settings.ai_chat).assistant()
    end
    if settings.ai_completion then
      require('plugin.code_assist.' .. settings.ai_completion).completion()
    end
  end
})
