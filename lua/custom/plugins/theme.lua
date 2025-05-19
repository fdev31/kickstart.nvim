local screensaver_timeout = 60 * 10 -- in seconds

local bg_color = '#100020'

return {
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
      local hover_color = {
        bg = '#2a3658',
      }
      local change_bg = '#154732' -- for diffview

      vim.api.nvim_set_hl(0, 'Special', { fg = '#ffaaac' })

      -- lsp auto hover
      vim.api.nvim_set_hl(0, 'LspReferenceText', hover_color)
      vim.api.nvim_set_hl(0, 'LspReferenceWrite', hover_color)
      vim.api.nvim_set_hl(0, 'LspReferenceRead', hover_color)
      -- diffview
      vim.api.nvim_set_hl(0, 'DiffChange', { bg = change_bg })
      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = change_bg })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#521414', fg = '#521414' })
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
    end,
  },
}
