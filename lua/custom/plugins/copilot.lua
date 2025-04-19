local settings = require 'custom.settings'

if not settings.useCopilot then
  return {}
end

local use_codecompanion = false

if use_codecompanion then
  table.insert(settings.cmp_sources, 'codecompanion')
  return {
    {
      'olimorris/codecompanion.nvim',
      opts = {
        strategies = {
          chat = {
            adapter = 'copilot',
          },
          inline = {
            adapter = 'copilot_fast',
          },
        },
        adapters = {
          copilot_fast = function()
            return require('codecompanion.adapters').extend 'copilot'
          end,
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-3.7-sonnet',
                },
              },
            })
          end,
        },
      },
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
    },
  }
else
  settings.cmp_providers.copilot = {
    name = 'copilot',
    module = 'blink-copilot',
    score_offset = 100,
    async = true,
  }
  table.insert(settings.cmp_sources, 'copilot')
  return {
    { 'fang2hou/blink-copilot', opts = {} },
    { 'zbirenbaum/copilot.lua', opts = {} },
    { 'CopilotC-Nvim/CopilotChat.nvim', opts = {} },
  }
end
