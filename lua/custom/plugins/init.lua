-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lib = require 'custom.lib'
local settings = require 'custom.settings'
M = {}

local plugins = {
  'theme',
  'git',
  'orgmode',
  'diffview',
  'markdown',
  'python',
  'silicon',
  'smooth_scroll',
  'workspaces',
  'menus',
  'qol',
  'daps',
  'filetypes',
  'copilot',
}

for _, plugin in ipairs(plugins) do
  local plug = require('custom.plugins.' .. plugin)
  lib.textend(M, plug)
  if plug.setup then
    plug.setup()
  end
end

for _, p in pairs(M) do
  if type(p) == 'table' and not p.opts then
    p.opts = {}
  end
end

return M
