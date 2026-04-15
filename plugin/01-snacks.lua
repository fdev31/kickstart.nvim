-- vim:ts=2:sw=2:et:
-- EAGER: core infrastructure plugin, many depend on it
vim.pack.add {
  'https://github.com/folke/snacks.nvim',
}

local notif_opts = { wo = { wrap = true } }

require('snacks').setup {
  picker = {
    sources = {
      notifications = {
        win = { preview = notif_opts },
      },
    },
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
}

Snacks.config.style('notification', notif_opts)
