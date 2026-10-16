local settings = require 'config.settings'
return {
  assistant = function()
    vim.pack.add {
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/olimorris/codecompanion.nvim',
    }
    settings.cmp_providers.codecompanion = {
      name = "CodeCompanion",
      module = "codecompanion.providers.completion.blink",
      enabled = true,
      score_offset = 100,
      async = true,
    }
    table.insert(settings.cmp_sources, 'codecompanion')

    require('codecompanion').setup {
      opts = {
        -- log_level = 'DEBUG',
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
                url = settings.llama_url,
                api_key = settings.llama_key,
                chat_url = '/v1/chat/completions',
              },
              schema = {
                model = { default = settings.ai_model}, --ignoré avec un seul model chargé
              },
            })
          end,
        },
      },
    }
  end
}
