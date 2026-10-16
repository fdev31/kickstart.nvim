local settings = require 'config.settings'

return {
    completion = function()
        local minuet_provider = "openai_compatible"
        vim.pack.add {
            'https://github.com/milanglacier/minuet-ai.nvim',
        }
        settings.cmp_providers.minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            score_offset = 100,
            async = true,
        }
        table.insert(settings.cmp_sources, 'minuet')
        require('minuet').setup({
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
                    model = settings.ai_model,
                    end_point = settings.llama_url .. '/v1/chat/completions',
                    api_key = 'OPENROUTER_API_KEY',
                    stream = false,
                    optional = {
                        reasoning_effort = 'low'
                    }
                }
            }
        })
    end
}
