-- vim:ts=2:sw=2:et:
-- DEFERRED: code navigation and enhancement plugins
require('lazyload').on_vim_enter(function()
  vim.pack.add({
    'https://github.com/onsails/lspkind.nvim',
    'https://github.com/stevearc/aerial.nvim',
    'https://github.com/m-demare/hlargs.nvim',
    'https://github.com/Wansmer/treesj',
    'https://github.com/nvim-flutter/flutter-tools.nvim',
  })

  require('aerial').setup({
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Prev Aerial match' })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Next Aerial match' })
    end,
  })
  vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = '[a]erial' })
  pcall(require('telescope').load_extension, 'aerial')

  local hlargs = require('hlargs')
  hlargs.setup({ color = '#ffaa00' })
  hlargs.enable()

  require('treesj').setup({ use_default_keymaps = false, max_join_length = 1000 })

  require('flutter-tools').setup({})
end)
