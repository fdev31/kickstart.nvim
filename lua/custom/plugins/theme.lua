return {
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
