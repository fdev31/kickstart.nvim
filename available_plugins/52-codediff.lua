-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

settings.diff_command = 'CodeDiff --side-by-side'

require('lazyload').on_lazy_commands({'CodeDiff'}, function()
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
end)
