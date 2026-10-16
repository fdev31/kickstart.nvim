-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: AI copilot
local settings = require 'config.settings'
local companion_model = settings.copilot_model
local llama_url = settings.llama_url

local companion_plugins = {}
local completion_plugins = {}

completion_plugins.minuet = function()

  vim.pack.add {
    'https://github.com/milanglacier/minuet-ai.nvim',
  }

  table.insert(settings.cmp_sources, 'minuet')
  settings.cmp_providers.minuet = {
    name = 'minuet',
    module = 'minuet.blink',
    score_offset = 100,
    async = true,
  }
  local minuet_provider = "openai_compatible"
  require('minuet').setup({
    blink = {
        enable_auto_complete = true,
    },
    provider = minuet_provider,
    notify = "debug",
    request_timeout = 40, -- Timeout in seconds for a single duet request.
    duet = {
      provider = minuet_provider,
    },
    provider_options = {
      [minuet_provider] = {
        model = 'qwen3.8-27b',
        end_point = llama_url .. '/v1/chat/completions',
        api_key = 'OPENROUTER_API_KEY',
        stream = false,
        optional = {
            reasoning_effort = 'low'
        }
      }
    }
  })
end
completion_plugins.copilot = function()
  -- Register copilot as a blink.cmp source
  settings.cmp_providers.copilot = {
    name = 'copilot',
    module = 'blink-copilot',
    score_offset = 100,
    async = true,
  }
  table.insert(settings.cmp_sources, 'copilot')
  vim.pack.add {
    'https://github.com/fang2hou/blink-copilot',
    'https://github.com/zbirenbaum/copilot.lua',
  }

  require('copilot').setup { copilot_node_command = vim.fn.exepath 'node' }

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.conceallevel = 0
    end,
  })
end

-- CODE COMPANION
companion_plugins.codecompanion = function()

  settings.cmp_providers.codecompanion = {
    name = "CodeCompanion",
    module = "codecompanion.providers.completion.blink",
    enabled = true,
    score_offset = 100,
    async = true,
  }

  vim.pack.add {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/olimorris/codecompanion.nvim',
  }
  require('codecompanion').setup {
    opts = {
      log_level = 'DEBUG',
    },
    interactions = {
      chat = { adapter = 'llama_cpp' },
      inline = { adapter = 'llama_cpp' },
    },
    adapters = {
      http = {
        llama_cpp = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            name = 'llama_cpp',
            formatted_name = 'llama.cpp',
            env = {
              url = llama_url,
              api_key = 'sk-no-key',
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = { default = companion_model }, --ignoré avec un seul model chargé
            },
          })
        end,
      },
      -- copilot = function()
      --   return require('codecompanion.adapters').extend('copilot', {
      --     schema = { model = { default = companion_model } },
      --   })
      -- end,
    },
  }

  table.insert(settings.cmp_sources, 'codecompanion')

end

-- COPILOT CHAT
companion_plugins.copilot = function()

  for _, cmd in ipairs { 'CopilotChat', 'CopilotChatOptimize' } do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      vim.pack.add {
        { src = 'https://github.com/CopilotC-Nvim/CopilotChat.nvim', version = 'main' },
      }
      require('CopilotChat').setup {
        agent = 'copilot',
        model = companion_model,
        temperature = 0.1,
        window = {
          layout = 'vertical',
          width = 0.5,
          border = settings.popup_style.border,
          title = '🤖 AI Assistant',
        },
        auto_insert_mode = false,
        headers = {
          user = '👤 You',
          assistant = ' Copilot',
          tool = '🔧 Tool',
        },
        auto_fold = true,
        separator = ' ──',
      }
      vim.cmd(cmd .. ' ' .. (opts.args or ''))
    end, { nargs = '*' })
  end
end

-- Chat
local backend = companion_plugins[settings.copilot_chat]
if backend ~= nil then
  backend()
end
-- Completion
vim.api.nvim_create_autocmd('VimEnter', {
  once=True,
  callback = function()
    backend = completion_plugins[settings.ai_completion]
    if backend ~= nil then
      backend()
    end
  end
})
