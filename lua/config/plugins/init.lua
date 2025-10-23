-- You can add your own plugins here or in other files in this directory!:
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
M = {}

local plugins = {
  'autocomplete',
  'autoformat',
  'code_goodies',
  'copilot',
  'daps',
  'diagnostics',
  'diffview',
  'embedded',
  'filetypes',
  'git',
  'http_client',
  'lsp',
  'markdown',
  'menus',
  'misc',
  'neotree',
  'orgmode',
  'python',
  'qol',
  'silicon',
  'smooth_scroll',
  'theme',
  'treesitter',
  'whichkey',
  'workspaces',
}

local load_plugin = function(plugin)
  local plug = require('config.plugins.' .. plugin)
  vim.list_extend(M, plug)
  if plug.setup then
    plug.setup()
  end
end

for _, plugin in ipairs(plugins) do
  local ret, msg = pcall(load_plugin, plugin)
  if not ret then
    vim.notify('Failed to load plugin ' .. plugin .. ': ' .. msg, vim.log.levels.ERROR)
  end
end

return M
