return {
  {
    'wolfwfr/vimatrix.nvim',
    lazy = false,
    opts = {
      window = {
        general = {
          zindex = 1000,
        },
      },
      -- logging = {
      --   print_errors = true,
      --   log_level = vim.log.levels.DEBUG,
      -- },
      auto_activation = {
        screensaver = {
          timeout = 60,
          setup_deferral = 1,
          ignore_focus = true,
          block_on_term = true,
          block_on_cmd_line = true,
        },
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
