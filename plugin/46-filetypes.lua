-- vim:ts=2:sw=2:et:
-- Filetype detection (runs eagerly, but plugins are lazy)
vim.filetype.add({
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  extension = {
    wiki = 'confluence_wiki',
  },
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function()
    vim.lsp.start({
      name = 'hyprlang',
      cmd = { os.getenv('HOME') .. '/.local/share/nvim/mason/packages/hyprls/hyprls' },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- Log highlight (schedule, not filetype-dependent)
vim.schedule(function()
  vim.pack.add({
    'https://github.com/fei6409/log-highlight.nvim',
  })
  require('log-highlight').setup({
    pattern = { 'xdev=.*' },
  })
end)

-- PlantUML
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'plantuml',
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/aklt/plantuml-syntax',
      'https://gitlab.com/itaranto/plantuml.nvim',
    })
    vim.o.spell = false
    vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
    require('plantuml').setup({
      renderer = {
        type = 'imv',
        options = { dark_mode = false, format = nil },
      },
      render_on_write = true,
    })
  end,
})

-- Just
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'just',
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/NoahTheDuke/vim-just' })
  end,
})
