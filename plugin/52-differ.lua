-- vim:ts=2:sw=2:et:
-- ON_CMD: diff viewer + merge tool
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'differ.nvim' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.system({ 'make', 'go-build' }, { cwd = ev.data.path }):wait()
    end
  end,
})
vim.pack.add({ 'https://github.com/undont/differ.nvim' })
require('differ').setup()
