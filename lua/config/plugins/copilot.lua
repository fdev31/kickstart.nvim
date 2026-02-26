-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

local use_codecompanion = settings.copilotChat == 'codecompanion'
local use_model = 'claude-opus-4.6'

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
  vim.g.copilot_no_tab_map = true
  vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
  -- Auto-command to customize chat buffer behavior
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.conceallevel = 0
    end,
  })

  table.insert(ai_plugins, {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = { 'CopilotChat', 'CopilotChatOptimize' },
    branch = 'main',
    opts = {
      agent = 'copilot',
      model = use_model,

      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float'
        width = 0.5, -- 50% of screen width
      },
      auto_insert_mode = false, -- Enter insert mode when opening

      -- question_header = 'Prompt ', -- Header to use for user questions
      -- answer_header = '  ', -- Header to use for AI answers
      -- error_header = '  ', -- Header to use for errors

      window = {
        -- layout = 'float',
        -- width = 80, -- Fixed width in columns
        -- height = 20, -- Fixed height in rows
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        title = '🤖 AI Assistant',
        -- zindex = 100, -- Ensure window stays on top
      },

      headers = {
        user = '👤 You',
        assistant = ' Copilot',
        tool = '🔧 Tool',
      },

      auto_fold = true,
      separator = ' ──', -- Separator to use in chat
    },
  })
end

return ai_plugins
