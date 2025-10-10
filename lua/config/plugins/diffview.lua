return {
  {
    'sindrets/diffview.nvim', -- better diff view
    event = 'VeryLazy',
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
