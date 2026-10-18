-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local lib = require 'config.lib.core'

require('lazyload').on_lazy_commands({ 'CodeDiff' }, function()
  settings.diff_command = 'DiffviewToggle'
  lib.plugin {
    'https://github.com/dlyongemallo/diffview-plus.nvim',
  }
  require('diffview').setup {
    enhanced_diff_hl = true,
    use_icons = true,
    view = {
      merge_tool = { layout = 'diff3_mixed' },
    },
    file_panel = {
      show = false,
    },
  }
  vim.api.nvim_create_user_command('CodeDiff', function(opts)
    vim.cmd(settings.diff_command .. ' ' .. (opts.args or ''))
  end, { nargs = '*' })
end)
