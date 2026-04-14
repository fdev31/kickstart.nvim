-- vim:ts=2:sw=2:et:
-- ON_CMD: workspace management
for _, cmd in ipairs({ 'WorkspacesOpen', 'WorkspacesAdd', 'WorkspacesList', 'WorkspacesRemove' }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    for _, c in ipairs({ 'WorkspacesOpen', 'WorkspacesAdd', 'WorkspacesList', 'WorkspacesRemove' }) do
      pcall(vim.api.nvim_del_user_command, c)
    end
    vim.pack.add({
      'https://github.com/natecraddock/workspaces.nvim',
    })
    pcall(require('telescope').load_extension, 'workspaces')
    require('workspaces').setup({
      hooks = {
        open = { 'Telescope find_files' },
      },
    })
    vim.cmd(cmd .. ' ' .. (opts.args or ''))
  end, { nargs = '*' })
end
