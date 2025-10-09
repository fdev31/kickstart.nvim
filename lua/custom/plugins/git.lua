return {
  { 'tpope/vim-fugitive', config = function() end },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '' },
        change = { text = '' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '' },
      },
      current_line_blame = true,
      numhl = true,
      signcolumn = true,
      sign_priority = 100,
    },
  },
}
