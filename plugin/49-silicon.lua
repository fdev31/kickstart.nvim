-- vim:ts=2:sw=2:et:
-- ON_CMD: code screenshots
local settings = require('config.settings')

vim.api.nvim_create_user_command('Silicon', function(opts)
  vim.api.nvim_del_user_command('Silicon')
  vim.pack.add({
    'https://github.com/michaelrommel/nvim-silicon',
  })
  require('nvim-silicon').setup({
    to_clipboard = true,
    output = '/tmp/code.png',
    tab_width = 2,
    theme = 'Dracula',
    font = 'Fira Code',
    shadow_blur_radius = 7,
    pad_horiz = 30,
    pad_vert = 30,
    shadow_color = '#100000',
  })
  vim.cmd('Silicon ' .. (opts.args or ''))
end, { nargs = '*', range = true })
