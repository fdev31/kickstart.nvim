return {
  {
    'wolfwfr/vimatrix.nvim',
    opts = {
      auto_activation = {
        screensaver = {
          timeout = 60,
        },
      },
      window = {
        border = nil,
      },
      alphabet = {
        built_in = { 'symbols' },
        custom = { '', '', '', '', '󰌽', '󰣇', '󱌵', '', '', '', '', '', '' },
        randomize_on_init = true,
        randomize_on_pick = false,
      },
    },
  },
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      transparent_bg = true,
      italic_comment = false,
    },
    init = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },
}
