-- vim:ts=2:sw=2:et:
-- ON_CMD: miscellaneous
vim.api.nvim_create_user_command('VimBeBetter', function(opts)
  vim.api.nvim_del_user_command('VimBeBetter')
  vim.pack.add({
    'https://github.com/szymonwilczek/vim-be-better',
  })
  vim.cmd('VimBeBetter ' .. (opts.args or ''))
end, { nargs = '*' })
