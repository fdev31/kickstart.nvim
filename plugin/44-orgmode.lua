-- vim:ts=2:sw=2:et:
-- ON_FT: orgmode
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/akinsho/org-bullets.nvim',
      'https://github.com/nvim-orgmode/orgmode',
    })

    require('orgmode').setup({
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
    })
    require('org-bullets').setup()
  end,
})
