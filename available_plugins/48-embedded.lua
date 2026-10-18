-- vim:ts=2:sw=2:et:
-- ON_CMD: PlatformIO
require('lazyload').on_lazy_commands({'Pioinit', 'Piorun', 'Piocmd', 'Piomon', 'Piodebug', 'Piolib' },
  function()
    vim.pack.add({
      'https://github.com/akinsho/nvim-toggleterm.lua',
      'https://github.com/anurag3301/nvim-platformio.lua',
    })
  end)

