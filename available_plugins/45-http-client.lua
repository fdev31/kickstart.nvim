-- vim:ts=2:sw=2:et:
-- ON_FT: HTTP client
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'http', 'rest' },
  once = true,
  callback = function(ev)
    vim.pack.add({
      'https://github.com/mistweaverco/kulala.nvim',
    })

    require('kulala').setup({
      global_keymaps = true,
      global_keymaps_prefix = '<leader>r',
      kulala_keymaps_prefix = '',
    })

    -- kulala.setup() registers a FileType autocmd to attach its LSP, but that
    -- autocmd is registered AFTER the FileType event for the current buffer
    -- has already fired. Attach manually for this buffer so completion works
    -- on the file that triggered the lazy-load.
    pcall(function()
      require('kulala.cmd.lsp').start(ev.buf, ev.match)
    end)
  end,
})
