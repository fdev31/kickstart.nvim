-- vim:ts=2:sw=2:et:
-- EAGER: LuaSnip must be on runtimepath early (needed by python.nvim etc.)
-- Build hook: compile jsregexp on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'LuaSnip' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      if vim.fn.executable 'make' == 1 then
        vim.fn.system { 'make', 'install_jsregexp', '-C', ev.data.path }
      end
    end
  end,
})
vim.pack.add {
  'https://github.com/L3MON4D3/LuaSnip',
}

-- DEFERRED: LSP + Mason
require('lazyload').on_vim_enter(function()
  local settings = require 'config.settings'

  vim.pack.add {
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    -- blink.cmp loaded here so get_lsp_capabilities() works
    'https://github.com/folke/lazydev.nvim',
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
  }

  require('lazydev').setup {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }

  require('mason').setup { ui = settings.popup_style }

  -- LSP servers: mason-lspconfig v2 handles installation + vim.lsp.enable()
  -- Python LSP selection is driven by settings.python_lsp ('pylsp' | 'ty' | 'both').
  -- Override per project in .nvim.lua BEFORE this runs (exrc fires during init).
  local py_exclude = {}
  if settings.python_lsp == 'pylsp' then
    table.insert(py_exclude, 'ty')
  elseif settings.python_lsp == 'ty' then
    table.insert(py_exclude, 'pylsp')
    -- 'both' → exclude nothing
  end

  require('mason-lspconfig').setup {
    automatic_enable = { exclude = py_exclude },
    ensure_installed = {
      'textlsp',
      'harper_ls',
      'dprint',
      'typos_lsp',
      'html',
      'ruff',
      'bashls',
      'cssls',
      'clangd',
      'vtsls',
      'eslint',
      'tailwindcss',
      'pylsp',
      'lua_ls',
      'qmlls',
      'tombi',
    },
  }

  -- ty isn't managed by mason-lspconfig's auto-enable; turn it on explicitly.
  if settings.python_lsp == 'ty' or settings.python_lsp == 'both' then
    vim.lsp.enable('ty')
  end

  -- Formatters/linters: mason-tool-installer handles non-LSP tools
  require('mason-tool-installer').setup {
    ensure_installed = { 'codespell', 'stylua', 'shfmt', 'prettierd', 'js-debug-adapter' },
  }

  -- blink.cmp capabilities for all servers
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  vim.lsp.config('*', { capabilities = capabilities })

  -- LspAttach autocmd
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      require 'config.keymaps.lsp'(client, event)

      -- Override built-in `grn`: when multiple LSP clients support rename,
      -- prompt once for which client to use (avoids duplicate rename prompts,
      -- e.g. pylsp + ty on Python buffers).
      vim.keymap.set('n', 'grn', function()
        local clients = vim.lsp.get_clients {
          bufnr = event.buf,
          method = 'textDocument/rename',
        }
        if #clients <= 1 then
          vim.lsp.buf.rename()
          return
        end
        vim.ui.select(clients, {
          prompt = 'Rename via which LSP client?',
          format_item = function(c)
            return c.name
          end,
        }, function(choice)
          if not choice then
            return
          end
          vim.lsp.buf.rename(nil, {
            filter = function(c)
              return c.id == choice.id
            end,
          })
        end)
      end, { buffer = event.buf, desc = 'Rename (choose client)' })

      vim.lsp.document_color.enable(false, { bufnr = event.buf })

      -- Skip colorizer for buffers where color preview is noise.
      local colorizer_skip = {
        log = true, gitcommit = true, help = true,
        ['TelescopeResults'] = true, ['neo-tree'] = true, [''] = true,
      }
      if not colorizer_skip[vim.bo[event.buf].filetype] then
        require('colorizer').attach_to_buffer(event.buf)
      end

      -- Enable linked editing range (auto-rename matching tags) when supported
      if client and client:supports_method 'textDocument/linkedEditingRange' then
        vim.lsp.linked_editing_range.enable(true, { bufnr = event.buf })
      end

      -- Code lens: refresh on attach and on buffer events. `grx` (built-in
      -- global mapping) runs the lens under the cursor.
      if client and client:supports_method 'textDocument/codeLens' then
        vim.lsp.codelens.refresh { bufnr = event.buf }
        vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
          buffer = event.buf,
          group = vim.api.nvim_create_augroup('lsp-codelens-' .. event.buf, { clear = true }),
          callback = function()
            vim.lsp.codelens.refresh { bufnr = event.buf }
          end,
        })
      end
      -- Prefer LSP folding when supported, fallback to treesitter
      local win = vim.api.nvim_get_current_win()
      if not vim.wo[win].diff then
        vim.wo[win][0].foldmethod = 'expr'
        if client and client:supports_method 'textDocument/foldingRange' then
          vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        elseif pcall(vim.treesitter.get_parser, event.buf) then
          vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[win][0].foldtext = 'v:lua.vim.treesitter.foldtext()'
        else
          vim.wo[win][0].foldmethod = 'syntax'
        end
      end
    end,
  })

  vim.lsp.log.set_level 'off'
end)
