-- vim:ts=2:sw=2:et:
-- SCHEDULE: LSP + Mason
vim.schedule(function()
  local settings = require('config.settings')
  local lib = require('config.lib.core')

  vim.pack.add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    -- blink.cmp loaded here too so get_lsp_capabilities() works
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/saghen/blink.cmp',
  })

  require('mason').setup({ ui = settings.popup_style })

  -- Server list (enabled servers only)
  local lsp_servers = {
    'textlsp', 'harper_ls', 'dprint', 'typos_lsp', 'html', 'ruff',
    'bashls', 'cssls', 'clangd', 'vtsls', 'eslint', 'tailwindcss',
    'pylsp', 'lua_ls', 'qmlls', 'ty',
  }

  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- Apply capabilities to all servers
  vim.lsp.config('*', { capabilities = capabilities })

  require('mason-lspconfig').setup({
    automatic_installation = true,
    automatic_enable = false,
  })

  -- Also ensure formatters/linters are installed
  local ensure_installed = vim.list_extend(
    vim.deepcopy(lsp_servers),
    vim.tbl_keys(require('conform').formatters_by_ft)
  )

  require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

  vim.lsp.enable(lsp_servers)

  -- LspAttach autocmd
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      require('config.keymaps.lsp')(client, event)
      vim.bo[event.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'

      if vim.treesitter.get_captures_at_cursor() then
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.o.foldmethod = 'expr'
        vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
      else
        vim.o.foldmethod = 'syntax'
      end
    end,
  })

  vim.lsp.set_log_level('off')

  -- Re-setup servers after Mason installs
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    callback = function()
      vim.schedule(function()
        vim.lsp.enable(lsp_servers)
      end)
    end,
  })
end)
