-- vim:ts=2:sw=2:et:
-- ON_EVENT InsertEnter: autocompletion setup
-- blink.cmp + LuaSnip are already on the runtimepath via 11-lsp.lua;
-- this file just configures blink.cmp on first InsertEnter.
local settings = require('config.settings')

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
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
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        prebuilt_binaries = { force_version = 'v1.*' },
      },
      signature = { enabled = true },
    })
  end,
})
