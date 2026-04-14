-- vim:ts=2:sw=2:et:
-- ON_CMD: git commands (fugitive, codediff)
-- gitsigns is in 03-gitsigns.lua (EAGER)

-- Fugitive: stub commands
for _, cmd in ipairs({ 'G', 'Git', 'Gvdiffsplit', 'GBrowse', 'Gedit', 'Gread', 'Gwrite' }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    -- Delete all stub commands
    for _, c in ipairs({ 'G', 'Git', 'Gvdiffsplit', 'GBrowse', 'Gedit', 'Gread', 'Gwrite' }) do
      pcall(vim.api.nvim_del_user_command, c)
    end
    vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
    vim.cmd(cmd .. ' ' .. (opts.args or ''))
  end, { nargs = '*', complete = 'file' })
end

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
