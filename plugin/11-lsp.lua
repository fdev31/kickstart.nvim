-- vim:ts=2:sw=2:et:
-- EAGER: LuaSnip must be on runtimepath early (needed by python.nvim etc.)
-- Build hook: compile jsregexp on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'LuaSnip' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      if vim.fn.executable('make') == 1 then
        vim.fn.system({ 'make', 'install_jsregexp', '-C', ev.data.path })
      end
    end
  end,
})
vim.pack.add({
  'https://github.com/L3MON4D3/LuaSnip',
})

-- DEFERRED: LSP + Mason
require('lazyload').on_vim_enter(function()
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

  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  })

  require('mason').setup({ ui = settings.popup_style })

  -- LSP servers: mason-lspconfig v2 handles installation + vim.lsp.enable()
  require('mason-lspconfig').setup({
    automatic_enable = true,
    ensure_installed = {
      'textlsp', 'harper_ls', 'dprint', 'typos_lsp', 'html', 'ruff',
      'bashls', 'cssls', 'clangd', 'vtsls', 'eslint', 'tailwindcss',
      'pylsp', 'lua_ls', 'qmlls', 'ty', 'tombi',
    },
  })

  -- Formatters/linters: mason-tool-installer handles non-LSP tools
  require('mason-tool-installer').setup({
    ensure_installed = { 'codespell', 'stylua', 'shfmt', 'prettierd', 'js-debug-adapter' },
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

      -- Enable linked editing range (auto-rename matching tags) when supported
      if client and client:supports_method('textDocument/linkedEditingRange') then
        vim.lsp.linked_editing_range.enable(true, { bufnr = event.buf })
      end

      -- Prefer LSP folding when supported, fallback to treesitter
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = 'expr'
      if client and client:supports_method('textDocument/foldingRange') then
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      elseif pcall(vim.treesitter.get_parser, event.buf) then
        vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[win][0].foldtext = 'v:lua.vim.treesitter.foldtext()'
      else
        vim.wo[win][0].foldmethod = 'syntax'
      end
    end,
  })

  vim.lsp.log.set_level('off')
end)
