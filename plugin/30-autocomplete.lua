-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: autocompletion
-- NOTE: blink.cmp is also loaded in 11-lsp.lua (for capabilities).
-- vim.pack.add() is idempotent so this is safe.
local settings = require('config.settings')

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/L3MON4D3/LuaSnip',
      'https://github.com/folke/lazydev.nvim',
      'https://github.com/saghen/blink.cmp',
    })

    require('lazydev').setup({
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    })

    require('blink.cmp').setup({
      keymap = {
        preset = 'super-tab',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = settings.cmp_sources,
        providers = settings.cmp_providers,
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    })
  end,
})
