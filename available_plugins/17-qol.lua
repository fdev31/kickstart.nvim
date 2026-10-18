-- vim:ts=2:sw=2:et:
-- DEFERRED: quality of life plugins
require('lazyload').on_vim_enter(function()
  local lib = require 'config.lib.core'
  lib.plugin {
    'https://github.com/NMAC427/guess-indent.nvim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/kkharji/sqlite.lua',
    'https://github.com/danielfalk/smart-open.nvim',
    'https://github.com/catgoose/nvim-colorizer.lua',
    'https://github.com/jtprogru/pack-ui.nvim',
    'https://github.com/karb94/neoscroll.nvim',
  }

  require('neoscroll').setup {
    duration_multiplier = 0.5,
    performance_mode = false,
  }

  require('guess-indent').setup()
  require('marks').setup()
  vim.api.nvim_set_hl(0, 'MarkSignHL', { link = 'AerialLine' })

  pcall(require('telescope').load_extension, 'smart_open')

  vim.lsp.document_color.enable(false)

  require('colorizer').setup {
    filetypes = { '*' },
    options = {
      css = true,
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      mode = 'background',
      display = {
        disable_document_color = true,
      },
    },
  }
  -- Per-buffer attach happens in plugin/11-lsp.lua on LspAttach.
end)
