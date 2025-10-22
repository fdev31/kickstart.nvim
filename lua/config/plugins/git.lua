-- vim:ts=2:sw=2:et:

local settings = require 'config.settings'

return {
  { 'tpope/vim-fugitive', event = 'VeryLazy', config = function() end },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = settings.gitsigns,
      current_line_blame = true,
      numhl = true,
      signcolumn = true,
      sign_priority = 100,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function kmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        kmap('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })
        kmap('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        kmap('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        kmap('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        kmap('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        kmap('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        kmap('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        kmap('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        kmap('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        kmap('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        kmap('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        kmap('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        kmap('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        kmap('n', '<leader>tB', gitsigns.toggle_current_line_blame, { desc = '[b]lame inline (git)' })
        kmap('n', '<leader>tx', gitsigns.preview_hunk_inline, { desc = 'show missing [x] (git)' })
      end,
    },
  },
}
