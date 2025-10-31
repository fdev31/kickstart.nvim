-- vim:ts=2:sw=2:et:
return {
  ---@module 'python'
  {
    'karloskar/poetry-nvim',
    ft = { 'python' },
    lazy = true,
    config = function()
      require('poetry-nvim').setup()
    end,
  },
  {
    'linux-cultist/venv-selector.nvim',
    ft = { 'python' },
    lazy = true,
    branch = 'main',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      -- Your options go here
      name = 'pyenv',
      auto_refresh = true,
    },
    -- event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    command = { 'VenvSelect' },
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[v]env [s]elect' },
    },
  },
  {
    'andymass/vim-matchup', -- nice language aware "%"
    ft = { 'python', 'lua', 'javascript', 'typescript', 'html', 'css', 'vim', 'rust', 'go' },
    lazy = true,
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      local mod = require 'match-up'
      mod.matchup_matchparen_offscreen = { method = 'popup' }
      mod.setup {}
    end,
  },
  {
    'joshzcold/python.nvim',
    ft = { 'python' },
    lazy = true,
    dependencies = {
      { 'mfussenegger/nvim-dap' },
      { 'mfussenegger/nvim-dap-python' },
      { 'neovim/nvim-lspconfig' },
      { 'L3MON4D3/LuaSnip' },
      { 'nvim-neotest/neotest' },
      { 'nvim-neotest/neotest-python' },
    },
    ---@type python.Config
    opts = { ---@diagnostic disable-line: missing-fields`
      python_lua_snippets = true,
    },
  },
}
