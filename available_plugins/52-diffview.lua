-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
-- DiffView
vim.api.nvim_create_user_command('CodeDiff', function(opts)
  vim.api.nvim_del_user_command 'CodeDiff'
  vim.pack.add {
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
  vim.cmd('DiffviewOpen ' .. (opts.args or ''))
end, { nargs = '*' })
settings.diff_command = 'DiffviewToggle'
