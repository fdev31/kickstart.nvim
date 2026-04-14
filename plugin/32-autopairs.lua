-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: auto pairs and auto tags
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/windwp/nvim-autopairs',
      'https://github.com/windwp/nvim-ts-autotag',
    })

    require('nvim-autopairs').setup({})
    require('nvim-ts-autotag').setup({})
  end,
})
