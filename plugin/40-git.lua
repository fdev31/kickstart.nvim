-- vim:ts=2:sw=2:et:
-- DEFERRED: fugitive (was VeryLazy in lazy.nvim, needed early for FugitiveStatusline)
-- ON_CMD: codediff
-- gitsigns is in 03-gitsigns.lua (EAGER)

-- Fugitive: load at VimEnter so FugitiveStatusline() is available
-- before first BufWritePre (used by conform's is_buffer_tracked check)
require('lazyload').on_vim_enter(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
end)

-- CodeDiff: stub command
vim.api.nvim_create_user_command('CodeDiff', function(opts)
  vim.api.nvim_del_user_command('CodeDiff')
  vim.pack.add({
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/esmuellert/codediff.nvim',
  })
  require('codediff').setup({
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
  })
  vim.cmd('CodeDiff ' .. (opts.args or ''))
end, { nargs = '*' })
