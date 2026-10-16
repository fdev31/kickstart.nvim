local settings = require 'config.settings'

return {
    completion = function()
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
}
