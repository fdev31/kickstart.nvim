local screensaver_timeout = 60 * 10 -- in seconds

return {
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      transparent_bg = not vim.g.neovide,
      italic_comment = true,
    },
    init = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },
}
