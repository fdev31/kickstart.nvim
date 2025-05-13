return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      stay_on_this_version = true,
      -- Your options go here
      name = 'pyenv',
      auto_refresh = true,
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[v]env [s]elect' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = '[v]env [c]ache' },
    },
    {
      'andymass/vim-matchup', -- nice language aware "%"
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        local mod = require 'match-up'
        mod.matchup_matchparen_offscreen = { method = 'popup' }
        mod.setup {}
      end,
    },
  },
}
