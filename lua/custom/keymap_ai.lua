local map = vim.keymap.set
local settings = require 'custom.settings'
--------------------------------------------------
-- AI FEATURES (COPILOT & CODECOMPANION)
--------------------------------------------------
map({ 'n', 'v' }, '<leader>cp', function()
  if settings.copilotChat == 'codecompanion' then
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == '\22' then
      vim.cmd "'<,'>CodeCompanion"
    else
      vim.cmd 'CodeCompanion'
    end
  end
end, { desc = '[p]rompt (AI)' })

map({ 'n', 'v' }, '<leader>cC', function()
  if settings.copilotChat == 'codecompanion' then
    vim.cmd('CodeCompanionChat', 'Toggle')
  else
    vim.cmd 'CopilotChat'
  end
end, { desc = '[C]hat (AI)' })

map({ 'n', 'v' }, '<leader>co', function()
  if settings.copilotChat == 'codecompanion' then
    vim.cmd 'CodeCompanionActions'
  else
    vim.cmd 'CopilotChatOptimize'
  end
end, { desc = 'AI [O]ptions' })
