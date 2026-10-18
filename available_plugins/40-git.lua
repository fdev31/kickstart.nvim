-- vim:ts=2:sw=2:et:
-- DEFERRED: fugitive (was VeryLazy in lazy.nvim, needed early for FugitiveStatusline)
-- ON_CMD: codediff
-- gitsigns is in 03-gitsigns.lua (EAGER)

-- Fugitive: load at VimEnter so FugitiveStatusline() is available
-- before first BufWritePre (used by conform's is_buffer_tracked check)
require('lazyload').on_vim_enter(function()
  vim.pack.add { 'https://github.com/tpope/vim-fugitive' }
end)
