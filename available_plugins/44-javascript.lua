-- vim:ts=2:sw=2:et:
-- ON_FT: JavaScript/TypeScript-specific plugins
local lib = require 'config.lib.core'
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  once = true,
  callback = function()
    lib.plugin {
      'https://github.com/nvim-neotest/neotest',
      'https://github.com/marilari88/neotest-vitest',
    }

    -- Neotest: register Vitest adapter (re-entrant, see lib/neotest.lua)
    require('config.lib.neotest').register(require 'neotest-vitest')
  end,
})
