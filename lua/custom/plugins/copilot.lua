local settings = require 'custom.settings'

if not settings.useCopilot then
  return {}
end

local use_codecompanion = settings.copilotChat == 'codecompanion'
local use_model = 'claude-3.7-sonnet'

settings.cmp_providers.copilot = {
  name = 'copilot',
  module = 'blink-copilot',
  score_offset = 100,
  async = true,
}
table.insert(settings.cmp_sources, 'copilot')

local ai_plugins = {
  { 'fang2hou/blink-copilot', event = 'InsertEnter' },
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = { copilot_node_command = '/usr/bin/node' },
  },
}

if use_codecompanion then
  table.insert(settings.cmp_sources, 'codecompanion')
  table.insert(ai_plugins, {
    'olimorris/codecompanion.nvim',
    opts = {
      log_level = 'DEBUG',
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = use_model,
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
  })
else
  table.insert(ai_plugins, {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = { 'CopilotChat', 'CopilotChatOptimize' },
    branch = 'main',
    opts = {
      agent = 'copilot',
      model = use_model,

      question_header = 'Prompt ', -- Header to use for user questions
      answer_header = '  ', -- Header to use for AI answers
      error_header = '  ', -- Header to use for errors
      separator = ' ──', -- Separator to use in chat
    },
  })
end

return ai_plugins
