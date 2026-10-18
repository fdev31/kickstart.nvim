return {
  completion = function()
    local settings = require 'config.settings'
    local minuet_provider = 'openai_fim_compatible'
    local lib = require 'config.lib.core'
    lib.add_package {
      'https://github.com/milanglacier/minuet-ai.nvim',
    }
    settings.cmp_providers.minuet = {
      name = 'minuet',
      module = 'minuet.blink',
      score_offset = 100,
      async = true,
    }
    table.insert(settings.cmp_sources, 'minuet')
    require('minuet').setup {
      blink = {
        enable_auto_complete = true,
      },
      provider = minuet_provider,
      -- notify = "debug",
      request_timeout = 40, -- Timeout in seconds for a single duet request.
      duet = {
        provider = minuet_provider,
      },
      provider_options = {
        [minuet_provider] = {
          model = settings.ai_fim_model,
          end_point = settings.llama_url .. '/v1/completions',
          api_key = settings.llama_key,
          name = 'local llama',
          stream = false,
          optional = {
            reasoning_effort = 'low',
          },
        },
      },
    }
  end,
}
