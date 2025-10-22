-- vim:ts=2:sw=2:et:
local lib = require 'config.lib.core'
local settings = require 'config.settings'

return {
  'NMAC427/guess-indent.nvim',
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git_branch', -- also try out "git"
      icons = false,
      status = false,
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
      { '<leader>M', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
      -- { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
      -- { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
    },
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    config = function()
      require('marks').setup()
      vim.api.nvim_set_hl(0, 'MarkSignHL', { link = 'AerialLine' })
    end,
  },
  {
    'folke/snacks.nvim', -- QoL (images, keymaps, ...)
    event = 'VeryLazy',
    ---@type snacks.Config
    opts = {
      notifier = {
        enabled = true,
        timeout = 3000,
      },
    },
    priority = 1000,
  },
  { 'stevearc/dressing.nvim', event = 'VeryLazy' }, -- better vim.ui (input, select, etc.)
  {
    'danielfalk/smart-open.nvim', -- magic open "anything"
    branch = '0.2.x',
    event = 'VeryLazy',
    config = function()
      require('telescope').load_extension 'smart_open'
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      'nvim-telescope/telescope.nvim',
      -- Only required if using match_algorithm fzf
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },
  {
    'norcalli/nvim-colorizer.lua', -- color preview
    config = function()
      require('colorizer').setup({ '*' }, {
        css = true,
        RRGGBBAA = true,
      })
    end,
  },
  { -- local neovim configuration for projects
    'klen/nvim-config-local',
    dependencies = { -- to show nice notifications
      'folke/snacks.nvim',
    },
    opts = {
      -- Config file patterns to load (lua supported)
      config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

      -- Where the plugin keeps files data
      hashfile = vim.fn.stdpath 'data' .. '/config-local',

      autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
      commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
      silent = false, -- Disable plugin messages (Config loaded/denied)
      lookup_parents = true, -- Lookup config files in parent directories
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.align').setup {
        mappings = {
          start = '',
          start_with_preview = 'gA',
        },
      }
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
  },
}
-- :ts=2:sw=2:et:
