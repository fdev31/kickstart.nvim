-- vim:ts=2:sw=2:et:
-- ON_CMD: diff viewer
local settings = require('config.settings')
settings.diff_command = 'DiffviewOpen -uno'
vim.g._diffview_enabled = true

vim.api.nvim_create_user_command('DiffviewOpen', function(opts)
  vim.api.nvim_del_user_command('DiffviewOpen')
  vim.pack.add({
    'https://github.com/sindrets/diffview.nvim',
  })
  require('diffview').setup({
    keymaps = {
      view = {
        { 'n', 'dl', require('diffview.actions').conflict_choose('ours'), { desc = 'Get left version (ours conflict)' } },
        { 'n', 'dr', require('diffview.actions').conflict_choose('theirs'), { desc = 'Get right version (theirs conflict)' } },
        { 'n', 'db', require('diffview.actions').conflict_choose('base'), { desc = 'Get original version (before conflict)' } },
      },
    },
    view = {
      merge_tool = { layout = 'diff3_mixed' },
    },
  })
  vim.cmd('DiffviewOpen ' .. (opts.args or ''))
end, { nargs = '*' })

-- Overseer: task runner (ON_CMD)
vim.api.nvim_create_user_command('OverseerRun', function(opts)
  for _, c in ipairs({ 'OverseerRun', 'OverseerToggle', 'OverseerOpen' }) do
    pcall(vim.api.nvim_del_user_command, c)
  end
  vim.pack.add({ 'https://github.com/stevearc/overseer.nvim' })
  require('overseer').setup({})
  vim.cmd('OverseerRun ' .. (opts.args or ''))
end, { nargs = '*' })
vim.api.nvim_create_user_command('OverseerToggle', function(opts)
  for _, c in ipairs({ 'OverseerRun', 'OverseerToggle', 'OverseerOpen' }) do
    pcall(vim.api.nvim_del_user_command, c)
  end
  vim.pack.add({ 'https://github.com/stevearc/overseer.nvim' })
  require('overseer').setup({})
  vim.cmd('OverseerToggle ' .. (opts.args or ''))
end, { nargs = '*' })
vim.api.nvim_create_user_command('OverseerOpen', function(opts)
  for _, c in ipairs({ 'OverseerRun', 'OverseerToggle', 'OverseerOpen' }) do
    pcall(vim.api.nvim_del_user_command, c)
  end
  vim.pack.add({ 'https://github.com/stevearc/overseer.nvim' })
  require('overseer').setup({})
  vim.cmd('OverseerOpen ' .. (opts.args or ''))
end, { nargs = '*' })
