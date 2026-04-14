-- vim:ts=2:sw=2:et:
-- SCHEDULE: key hints popup
vim.schedule(function()
  local settings = require('config.settings')

  vim.pack.add({
    'https://github.com/folke/which-key.nvim',
  })

  require('which-key').setup({
    delay = 100,
    win = settings.popup_style,
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '↑ ',
        Down = '↓ ',
        Left = '← ',
        Right = '→ ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '󰌑  ',
        Esc = '<Esc> ',
        ScrollWheelDown = '󱕒 ↓ ',
        ScrollWheelUp = '󱕒 ↑ ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '󱁐 ',
        Tab = '󰌒 ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
    spec = {
      { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
      { '<leader>d', group = 'Debugging' },
      { '<leader>R', group = 'Request' },
      { '<leader>g', group = 'Git' },
      { '<leader>d', group = 'Debugger' },
      { '<leader>f', group = 'Find' },
      { '<leader>o', group = 'Org' },
      { '<leader>r', group = 'Run' },
      { '<leader>t', group = 'Toggle' },
      { '<leader>h', group = 'Hunks (git)', mode = { 'n', 'v' } },
      { '<leader>v', group = 'Venv' },
      { '<leader>w', group = 'Workspaces' },
    },
  })
end)
