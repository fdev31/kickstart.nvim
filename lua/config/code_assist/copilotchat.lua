local settings = require 'config.settings'

return {
    assistant = function()
        for _, cmd in ipairs { 'CopilotChat', 'CopilotChatOptimize' } do
            vim.api.nvim_create_user_command(cmd, function(opts)
                vim.api.nvim_del_user_command(cmd)
                vim.pack.add {
                    { src = 'https://github.com/CopilotC-Nvim/CopilotChat.nvim', version = 'main' },
                }
                require('CopilotChat').setup {
                    agent = 'copilot',
                    model = settings.ai_model,
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
}
