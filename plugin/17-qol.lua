-- vim:ts=2:sw=2:et:
-- DEFERRED: quality of life plugins
require('lazyload').on_vim_enter(function()
  vim.pack.add {
    'https://github.com/NMAC427/guess-indent.nvim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/kkharji/sqlite.lua',
    'https://github.com/nvim-telescope/telescope-fzy-native.nvim',
    'https://github.com/danielfalk/smart-open.nvim',
    'https://github.com/catgoose/nvim-colorizer.lua',
  }

  require('marks').setup()
  vim.api.nvim_set_hl(0, 'MarkSignHL', { link = 'AerialLine' })

  pcall(require('telescope').load_extension, 'smart_open')

  require('colorizer').setup({ '*' }, {
    css = true,
    RRGGBBAA = true,
  })
end)
