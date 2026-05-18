-- vim:ts=2:sw=2:et:

-- Overseer: task runner (ON_CMD)
local function load_overseer(cmd, args)
  for _, c in ipairs { 'OverseerRun', 'OverseerToggle', 'OverseerOpen' } do
    pcall(vim.api.nvim_del_user_command, c)
  end
  vim.pack.add { 'https://github.com/stevearc/overseer.nvim' }
  require('overseer').setup {}
  vim.cmd(cmd .. ' ' .. (args or ''))
end

for _, cmd in ipairs { 'OverseerRun', 'OverseerToggle', 'OverseerOpen' } do
  vim.api.nvim_create_user_command(cmd, function(opts)
    load_overseer(cmd, opts.args)
  end, { nargs = '*' })
end
