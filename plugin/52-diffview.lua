-- vim:ts=2:sw=2:et:
-- ON_CMD: diff viewer
vim.api.nvim_create_user_command('DiffviewOpen', function(opts)
  vim.api.nvim_del_user_command 'DiffviewOpen'
  vim.pack.add {
    'https://github.com/sindrets/diffview.nvim',
  }
  local actions = require 'diffview.actions'
  require('diffview').setup {
    view = {
      merge_tool = { layout = 'diff3_mixed' },
    },
  }
  vim.cmd('DiffviewOpen ' .. (opts.args or ''))
end, { nargs = '*' })
