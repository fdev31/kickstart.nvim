-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lib = require 'custom.lib'
local settings = require 'custom.settings'
M = {}

local plugins = {
  'copilot',
  'daps',
  'diagnostics',
  'diffview',
  'embedded',
  'filetypes',
  'git',
  'http_client',
  'markdown',
  'menus',
  'orgmode',
  'python',
  'qol',
  'silicon',
  'smooth_scroll',
  'theme',
  'workspaces',
  'misc',
  'treesitter',
  'lsp',
  'neotree',
}

function load_plugin(plugin)
  local plug = require('custom.plugins.' .. plugin)
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

for _, p in ipairs(M) do
  if type(p) == 'table' then
    if not p.opts then
      p.opts = {}
    end
  end
end

return M
