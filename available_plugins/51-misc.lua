-- vim:ts=2:sw=2:et:
-- ON_CMD: miscellaneous
require('lazyload').on_lazy_commands({
  'VimBeBetter',
}, function(opts)
  vim.pack.add({'https://github.com/szymonwilczek/vim-be-better'})
end)
