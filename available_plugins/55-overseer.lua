-- vim:ts=2:sw=2:et:

require('lazyload').on_lazy_commands({
  'OverseerRun',
  'OverseerToggle',
  'OverseerOpen',
}, function()
  vim.pack.add { 'https://github.com/stevearc/overseer.nvim' }
  require('overseer').setup {}
end)
