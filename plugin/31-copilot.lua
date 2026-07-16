-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: AI copilot
local settings = require 'config.settings'
local companion_model = settings.copilot_model

-- Register copilot as a blink.cmp source
settings.cmp_providers.copilot = {
  name = 'copilot',
  module = 'blink-copilot',
  score_offset = 100,
  async = true,
}
table.insert(settings.cmp_sources, 'copilot')

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add {
      'https://github.com/fang2hou/blink-copilot',
      'https://github.com/zbirenbaum/copilot.lua',
    }

    require('copilot').setup { copilot_node_command = vim.fn.exepath 'node' }
  end,
})

local companion_plugins = {}
-- CODE COMPANION
companion_plugins.codecompanion = function()
  table.insert(settings.cmp_sources, 'codecompanion')
  for _, cmd in ipairs { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' } do
    vim.api.nvim_create_user_command(cmd, function(opts)
      vim.api.nvim_del_user_command(cmd)
      vim.pack.add {
        'https://github.com/olimorris/codecompanion.nvim',
      }
      require('codecompanion').setup {
        log_level = 'DEBUG',
        strategies = {
          chat = { adapter = 'copilot' },
          inline = { adapter = 'copilot' },
        },
        adapters = {
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = { model = { default = companion_model } },
            })
          end,
        },
      }
      vim.cmd(cmd .. ' ' .. (opts.args or ''))
    end, { nargs = '*' })
  end
end

-- COPILOT CHAT
companion_plugins.copilot = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.conceallevel = 0
    end,
  })

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

companion_plugins[settings.copilot_chat]()
