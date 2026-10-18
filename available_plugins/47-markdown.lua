-- vim:ts=2:sw=2:et:
-- ON_FT: markdown and wiki
local settings = require('config.settings')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'codecompanion' },
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    })
  end,
})

-- Telekasten: wiki (command-triggered)
local _telekasten_loaded = false
function _G.ensure_telekasten_loaded()
  if _telekasten_loaded then return end
  _telekasten_loaded = true
  pcall(vim.api.nvim_del_user_command, 'Telekasten')
  vim.pack.add({
    'https://github.com/renerocksai/telekasten.nvim',
  })
  require('telekasten').setup({
    home = settings.wiki_folder,
  })
end

require('lazyload').on_lazy_commands({'Telekasten'},
  _G.ensure_telekasten_loaded
)
