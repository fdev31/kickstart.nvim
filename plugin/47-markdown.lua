-- vim:ts=2:sw=2:et:
-- ON_FT: markdown and wiki
local settings = require('config.settings')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'codecompanion' },
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    })
  end,
})

-- Telekasten: wiki (command-triggered)
for _, cmd in ipairs({ 'Telekasten' }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    vim.api.nvim_del_user_command(cmd)
    vim.pack.add({
      'https://github.com/renerocksai/telekasten.nvim',
    })
    require('telekasten').setup({
      home = settings.wiki_folder,
    })
    vim.cmd(cmd .. ' ' .. (opts.args or ''))
  end, { nargs = '*' })
end
