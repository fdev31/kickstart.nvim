return {
  {
    'sindrets/diffview.nvim', -- better diff view
    event = function()
      -- Check if started with diff arguments (vim -d)
      if vim.o.diff or vim.tbl_contains(vim.v.argv, '-d') then
        return 'VimEnter' -- Load immediately in diff mode
      else
        return 'VeryLazy' -- Load lazily for normal use
      end
    end,
    config = function()
      require('diffview').setup { -- {{{
        keymaps = {
          view = {
            {
              'n',
              'dl',
              require('diffview.actions').conflict_choose 'ours',
              { desc = 'Get left version (ours conflict)' },
            },
            {
              'n',
              'dr',
              require('diffview.actions').conflict_choose 'theirs',
              { desc = 'Get right version (theirs conflict)' },
            },
            {
              'n',
              'db',
              require('diffview.actions').conflict_choose 'base',
              { desc = 'Get original version (before conflict)' },
            },
          },
        },
        view = {
          merge_tool = {
            layout = 'diff3_mixed',
          },
        },
      } -- }}}
    end,
  },
}
