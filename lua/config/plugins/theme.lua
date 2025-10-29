-- vim:ts=2:sw=2:et:
local screensaver_timeout = 60 * 10 -- in seconds

local bg_color = '#100020'

return {
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      transparent_bg = not vim.g.neovide,
      italic_comment = true,
      colors = {
        bg = bg_color,
      },
    },
    init = function()
      vim.cmd.colorscheme 'dracula'
      if vim.g.neovide then
        vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = bg_color })
      end
      -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = bg_color' })
      -- style

      local no_background = { ctermbg = nil, guibg = nil, bg = nil }
      local sideColor = '#282a36'
      local change_bg = '#154732' -- for diffview

      vim.api.nvim_set_hl(0, 'Special', { fg = '#ffaaac' })

      -- diffview
      vim.api.nvim_set_hl(0, 'DiffChange', { bg = change_bg })
      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = change_bg })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#521414', fg = '#f29924' })
      vim.api.nvim_set_hl(0, 'DiffText', { bold = true, bg = '#ddffee', fg = change_bg })
      -- transparent backgrounds
      vim.api.nvim_set_hl(0, 'NormalFloat', no_background)
      vim.api.nvim_set_hl(0, 'TabLineFill', no_background)
      vim.api.nvim_set_hl(0, 'StatusLine', no_background)
      vim.api.nvim_set_hl(0, 'TelescopeNormal', vim.tbl_deep_extend('force', { fg = '#d8d8f2' }, no_background))
      -- cursor
      vim.api.nvim_set_hl(0, 'Cursor', { fg = '#000000', bg = '#FFaa33' })
      vim.api.nvim_set_hl(0, 'Cursor2', { fg = '#000000', bg = '#FF0066' })
      vim.o.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50'
      require 'config.colors'
    end,
  },
}
