-- vim:ts=2:sw=2:et:
-- EAGER: LuaSnip must be on runtimepath early (needed by python.nvim etc.)
vim.pack.add({
  'https://github.com/L3MON4D3/LuaSnip',
})

-- SCHEDULE: LSP + Mason
vim.schedule(function()
  local settings = require('config.settings')

  vim.pack.add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    -- blink.cmp loaded here so get_lsp_capabilities() works
    'https://github.com/folke/lazydev.nvim',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
  })

  require('mason').setup({ ui = settings.popup_style })

  -- LSP servers: mason-lspconfig v2 handles installation + vim.lsp.enable()
  require('mason-lspconfig').setup({
    automatic_enable = true,
    ensure_installed = {
      'textlsp', 'harper_ls', 'dprint', 'typos_lsp', 'html', 'ruff',
      'bashls', 'cssls', 'clangd', 'vtsls', 'eslint', 'tailwindcss',
      'pylsp', 'lua_ls', 'qmlls', 'ty',
    },
  })

  -- Formatters/linters: mason-tool-installer handles non-LSP tools
  require('mason-tool-installer').setup({
    ensure_installed = { 'codespell', 'stylua', 'shfmt', 'prettierd' },
  })

  -- blink.cmp capabilities for all servers
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  vim.lsp.config('*', { capabilities = capabilities })

  -- LspAttach autocmd
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      require('config.keymaps.lsp')(client, event)
      vim.bo[event.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'

      local has_parser = pcall(vim.treesitter.get_parser, event.buf)
      if has_parser then
        vim.wo[0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0].foldmethod = 'expr'
        vim.wo[0].foldtext = 'v:lua.vim.treesitter.foldtext()'
      else
        vim.wo[0].foldmethod = 'syntax'
      end
    end,
  })

  vim.lsp.log.set_level('off')
end)
