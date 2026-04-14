-- vim:ts=2:sw=2:et:
-- EAGER: core infrastructure plugin, many depend on it
vim.pack.add({
  'https://github.com/folke/snacks.nvim',
})

require('snacks').setup({
  picker = {
    smart = {
      multi = { 'recent', 'buffers', 'files' },
      format = 'file',
      matcher = {
        cwd_bonus = true,
        frecency = true,
        sort_empty = true,
      },
      transform = 'unique_file',
    },
  },
  indent = {
    chunk = {
      enabled = false,
      char = {
        corner_top = '╭',
        corner_bottom = '╰',
        arrow = '𜰉',
      },
    },
  },
  input = {},
  notifier = { timeout = 3000 },
})
