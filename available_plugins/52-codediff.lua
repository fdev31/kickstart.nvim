-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
-- CodeDiff
vim.api.nvim_create_user_command('CodeDiff', function(opts)
  vim.api.nvim_del_user_command 'CodeDiff'
  vim.pack.add {
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/esmuellert/codediff.nvim',
  }
  require('codediff').setup {
    diff = {
      original_position = 'right',
      conflict_ours_position = 'left',
    },
    explorer = {
      position = 'bottom',
      initial_focus = 'modified',
      file_filter = {
        ignore = { '*.orig', '*.rej', '*.lock' },
      },
    },
  }
  vim.cmd('CodeDiff ' .. (opts.args or ''))
end, { nargs = '*' })
settings.diff_command = 'CodeDiff --side-by-side'
