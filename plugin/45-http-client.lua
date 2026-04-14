-- vim:ts=2:sw=2:et:
-- ON_FT: HTTP client
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'http', 'rest' },
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/mistweaverco/kulala.nvim',
    })

    require('kulala').setup({
      global_keymaps = true,
      global_keymaps_prefix = '<leader>r',
      kulala_keymaps_prefix = '',
    })
  end,
})
