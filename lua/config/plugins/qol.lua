-- vim:ts=2:sw=2:et:
local lib = require 'config.lib.core'
local settings = require 'config.settings'

local _filter_node = function(node_type)
  return true
  -- return node_type:match 'class_definition' or node_type:match 'module' or node_type:match 'function' or node_type:match 'method'
end

local render_statusline = function()
  local location = '%2l:%-2v'
  -- Get current function/method name using Treesitter
  local ts_utils = require 'nvim-treesitter.ts_utils'
  local ok, node = pcall(ts_utils.get_node_at_cursor)

  local first = true
  if ok and node then
    while node do
      local node_type = node:type()
      if _filter_node(node_type) then
        local name_node = node:field('name')[1]
        if name_node then
          local func_name = lib.clean_string(vim.treesitter.get_node_text(name_node, 0), 20)
          if first then
            location = func_name .. '▐ ' .. location
            first = false
          else
            location = func_name .. '.' .. location
          end
        end
      end
      node = node:parent()
    end
  end

  if vim.b._lsp_client_name then
    if not location then
      return vim.b._lsp_client_name
    else
      return vim.b._lsp_client_name .. '▐ ' .. location
    end
  end
  return location
end

return {
  'NMAC427/guess-indent.nvim',
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
      picker = {
        smart = {
          multi = { 'recent', 'buffers', 'files' },
          format = 'file', -- use `file` format for all sources
          matcher = {
            cwd_bonus = true, -- boost cwd matches
            frecency = true, -- use frecency boosting
            sort_empty = true, -- sort even when the filter is empty
          },
          transform = 'unique_file',
        },
      },
      indent = {},
      input = {},
      notifier = { timeout = 3000 },
    },
    priority = 1000,
  },
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
    'echasnovski/mini.nvim', --  Check out: https://github.com/echasnovski/mini.nvim
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_set_hl(0, 'MiniCursorword', { link = 'LspReferenceText' })
      require('mini.cursorword').setup { delay = 300 }
      -- require('mini.indentscope').setup {
      --   symbol = '┆',
      -- }
      require('mini.align').setup {
        mappings = {
          start = '',
          start_with_preview = 'gA',
        },
      }
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = render_statusline
    end,
  },
}
-- :ts=2:sw=2:et:
