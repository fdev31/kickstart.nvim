-- vim:ts=2:sw=2:et:
-- ON_FT: Python-specific plugins
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/nvim-neotest/nvim-nio',
      'https://github.com/karloskar/poetry-nvim',
      'https://github.com/linux-cultist/venv-selector.nvim',
      'https://github.com/nvim-neotest/neotest',
      'https://github.com/nvim-neotest/neotest-python',
      'https://github.com/joshzcold/python.nvim',
    })

    require('poetry-nvim').setup()

    require('venv-selector').setup({
      name = 'pyenv',
      auto_refresh = true,
    })

    require('python').setup({
      python_lua_snippets = true,
    })

    -- Neotest: register Python adapter (re-entrant, see lib/neotest.lua)
    require('config.lib.neotest').register(
      require('neotest-python')({
        dap = { justMyCode = false },
        runner = 'pytest',
      })
    )

    vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>', { desc = '[v]env [s]elect' })
  end,
})

-- vim-matchup: loads on multiple filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua', 'javascript', 'typescript', 'html', 'css', 'vim', 'rust', 'go' },
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/andymass/vim-matchup',
    })
    local mod = require('match-up')
    mod.matchup_matchparen_offscreen = { method = 'popup' }
    mod.setup({})
  end,
})
