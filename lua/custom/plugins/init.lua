-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local lib = require 'custom.lib'
local settings = require 'custom.settings'
M = {}

local plugins = {
  'custom.plugins.theme',
  'custom.plugins.git',
  'custom.plugins.orgmode',
  'custom.plugins.diffview',
  'custom.plugins.markdown',
  'custom.plugins.python',
  'custom.plugins.silicon',
  'custom.plugins.smooth_scroll',
  'custom.plugins.workspaces',
  'custom.plugins.menus',
  'custom.plugins.qol',
  'custom.plugins.daps',
  'custom.plugins.filetypes',
}

for _, plugin in ipairs(plugins) do
  lib.extend(M, require(plugin))
end

if settings.useCopilot then
  lib.extend(settings.cmp_dependencies, require 'custom.plugins.copilot')
  settings.cmp_providers.copilot = {
    name = 'copilot',
    module = 'blink-copilot',
    score_offset = 100,
    async = true,
  }
  table.insert(settings.cmp_sources, 'copilot')
end

return M
