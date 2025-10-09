local settings = require 'custom.settings'
local lib = require 'custom.lib'

local lsp_servers = {
  qmlls = {
    cmd = { 'qmlls' },
    root_dir = function(fname)
      return require('lspconfig.util').find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    filetypes = { 'qml' },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
            commitCharactersSupport = true,
          },
        },
      },
    },
  },
  textlsp = {},
  harper_ls = {
    ['harper-ls'] = {
      fileDictPath = '~/.config/nvim/spell/en.utf-8.add',
    },
  },
  dprint = {},
  typos_lsp = {},
  html = {},
  ruff = { enabled = true, formatEnabled = true },
  pylint = { enabled = false },
  pyright = { enabled = false },
  pycodestyle = { enabled = false }, -- in pylsp
  bashls = {},
  black = { enabled = false },
  cssls = {},
  clangd = {},
  ts_ls = {},
  vtsls = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            vue_plugin,
          },
        },
      },
    },
  },
  pyflakes = { enabled = false },
  eslint = {},
  tailwindcss = {},
  mypy = { enabled = false },
  -- python_lsp_isort = {},
  pylsp = {
    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    settings = {
      pylsp = {
        signature_ = {
          formatter = 'ruff',
        },
        plugins = {
          -- formatter options
          autopep8 = { enabled = false },
          yapf = { enabled = true },
          -- linter options
          mccabe = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = true },
          pydocstyle = { enabled = true },
          -- type checker
          pylsp_mypy = { enabled = false },
          -- auto-completion options
          jedi_completion = { fuzzy = true },
          -- navigation-related plugins
          -- rope_completion = { enabled = true },
          -- rope_autoimport = { enabled = true },
          -- jedi_completion = { enabled = true },
          -- jedi_definition = { enabled = true },
          -- jedi_hover = { enabled = true },
          -- jedi_references = { enabled = true },
          -- jedi_signature_help = { enabled = true },
          jedi_symbols = { enabled = true },
        },
      },
    },
  },
  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

local M = {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = { ui = settings.popup_style } },
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      vim.lsp.set_log_level 'off'
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          require 'custom.keymap_lsp'(client, event)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config(settings.diagnostic_config)

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = lib.filter_prop(lsp_servers, 'enabled', false)

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local active_lsp_servers = servers or {}

      vim.tbl_extend('keep', active_lsp_servers, require('conform').formatters_by_ft)

      require('mason-lspconfig').setup {
        automatic_installation = true,
        automatic_enable = false,
      }
      function setup_servers()
        for server_name in pairs(active_lsp_servers) do
          local srv_config = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          srv_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, srv_config.capabilities or {})
          vim.lsp.config(server_name, srv_config) -- NOTE: Replaces: require('lspconfig')[server_name].setup(srv_config)
        end
      end
      setup_servers()
      vim.lsp.enable(vim.tbl_keys(active_lsp_servers))
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function(e)
          vim.notify '  Ready!'
          vim.schedule(setup_servers)
        end,
      })
    end,
  },
}
return M
