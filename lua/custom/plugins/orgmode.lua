return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup {
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      }
      require('org-bullets').setup()
    end,
  },
  { 'akinsho/org-bullets.nvim' }, -- bulletpoints in org mode
}
