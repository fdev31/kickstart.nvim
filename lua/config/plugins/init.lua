M = {}

local async_setup = true

local settings = require 'config.settings'

local load_plugin = function(plugin)
  local plug = require('config.plugins.' .. plugin)
  vim.list_extend(M, plug)
  if plug.setup then
    if async_setup then
      vim.schedule(plug.setup)
    else
      if not pcall(plug.setup) then
        vim.notify('Error in setup for plugin ' .. plugin, vim.log.levels.ERROR, { title = 'Plugin setup' })
      end
    end
  end
end

for _, plugin in ipairs(settings.plugins) do
  local ret, msg = pcall(load_plugin, plugin)
  if not ret then
    vim.notify('Failed to load ' .. plugin .. ': ' .. msg, vim.log.levels.ERROR, { title = 'Plugin loader' })
  end
end

return M
