-- vim:ts=2:sw=2:et:
-- ON_CMD: workspace management
local _workspaces_loaded = false
function _G.ensure_workspaces_loaded()
  if _workspaces_loaded then
    return
  end
  _workspaces_loaded = true
  for _, c in ipairs { 'WorkspacesOpen', 'WorkspacesAdd', 'WorkspacesList', 'WorkspacesRemove' } do
    pcall(vim.api.nvim_del_user_command, c)
  end
  local lib = require 'config.lib.core'
  lib.plugin {
    'https://github.com/natecraddock/workspaces.nvim',
  }
  pcall(require('telescope').load_extension, 'workspaces')
  require('workspaces').setup {
    hooks = {
      open = { 'Telescope find_files' },
    },
  }
end

require('lazyload').on_lazy_commands({
  'WorkspacesOpen',
  'WorkspacesAdd',
  'WorkspacesList',
  'WorkspacesRemove',
}, _G.ensure_workspaces_loaded)
