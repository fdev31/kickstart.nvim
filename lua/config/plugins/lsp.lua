-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local lib = require 'config.lib.core'

local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local lsp_servers = {
  qmlls = {
    cmd = { 'qmlls' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = '.', upwards = true })[1])
      -- return require('lspconfig.util').find_git_ancestor(fname) or vim.fn.getcwd()
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
  { 'WhoIsSethDaniel/mason-tool-installer.nvim', event = 'VeryLazy' },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = { ui = settings.popup_style } },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      vim.lsp.set_log_level 'off'
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          require 'config.keymaps.lsp'(client, event)
          -- vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc' -- using blink.cmp
          vim.bo[event.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'

          if require('nvim-treesitter.parsers').has_parser() then
            vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.o.foldmethod = 'expr'
            vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
          else
            vim.o.foldmethod = 'syntax'
          end
        end,
      })
      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = lib.filter_prop(lsp_servers, 'enabled', false)
      local active_lsp_servers = vim.tbl_keys(servers) or {}

      vim.tbl_extend('keep', active_lsp_servers, vim.tbl_keys(require('conform').formatters_by_ft))

      require('mason-lspconfig').setup {
        automatic_installation = true,
        automatic_enable = false,
      }
      function setup_servers()
        for _, server_name in pairs(active_lsp_servers) do
          local srv_config = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          srv_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, srv_config.capabilities or {})
          vim.lsp.config(server_name, srv_config) -- NOTE: Replaces: require('lspconfig')[server_name].setup(srv_config)
        end
      end
      require('mason-tool-installer').setup { ensure_installed = active_lsp_servers }
      setup_servers()
      vim.lsp.enable(active_lsp_servers)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MasonToolsUpdateCompleted',
        callback = function(e)
          vim.schedule(setup_servers)
        end,
      })
    end,
  },
}
return M
