-- vim:ts=2:sw=2:et:
-- ON_CMD: PlatformIO
for _, cmd in ipairs({ 'Pioinit', 'Piorun', 'Piocmd', 'Piomon', 'Piodebug', 'Piolib' }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    for _, c in ipairs({ 'Pioinit', 'Piorun', 'Piocmd', 'Piomon', 'Piodebug', 'Piolib' }) do
      pcall(vim.api.nvim_del_user_command, c)
    end
    vim.pack.add({
      'https://github.com/akinsho/nvim-toggleterm.lua',
      'https://github.com/anurag3301/nvim-platformio.lua',
    })
    vim.cmd(cmd .. ' ' .. (opts.args or ''))
  end, { nargs = '*' })
end
