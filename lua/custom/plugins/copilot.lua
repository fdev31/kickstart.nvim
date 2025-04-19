local settings = require 'custom.settings'

if not settings.useCopilot then
  return {}
end

return {
  { 'fang2hou/blink-copilot', opts = {} },
  { 'zbirenbaum/copilot.lua', opts = {} },
  { 'CopilotC-Nvim/CopilotChat.nvim', opts = {} },

  setup = function()
    settings.cmp_providers.copilot = {
      name = 'copilot',
      module = 'blink-copilot',
      score_offset = 100,
      async = true,
    }
    table.insert(settings.cmp_sources, 'copilot')
  end,
}
