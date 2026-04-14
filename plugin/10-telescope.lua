-- vim:ts=2:sw=2:et:
-- SCHEDULE: core fuzzy finder, many plugins depend on it
vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
  })

  require('telescope').setup({
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      aerial = {
        highlight_on_hover = true,
        highlight_on_closest = true,
        autojump = true,
        show_guides = true,
        show_nesting = {
          ['_'] = true,
          python = true,
          js = true,
        },
      },
    },
  })

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
end)
