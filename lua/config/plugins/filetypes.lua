-- vim:ts=2:sw=2:et:
vim.filetype.add {
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
  extension = {
    wiki = 'confluence_wiki',
  },
}
-- Hyprlang syntax & LSP
-- LspInstall hyprlang
-- go install github.com/hyprland-community/hyprls/cmd/hyprls@latest
--
local autocmd = vim.api.nvim_create_autocmd

autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function(event)
    vim.lsp.start {
      name = 'hyprlang',
      cmd = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/hyprls/hyprls' },
      root_dir = vim.fn.getcwd(),
    }
  end,
})

return {
  {
    'fei6409/log-highlight.nvim', -- better log files
    event = 'VeryLazy',
    config = function()
      require('log-highlight').setup {
        pattern = {
          'xdev=.*',
        },
      }
    end,
  },
  {
    'aklt/plantuml-syntax',
    ft = 'plantuml',
    config = function()
      vim.o.spell = false
      vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
    end,
  },
  {
    'https://gitlab.com/itaranto/plantuml.nvim',
    version = '*',
    dependencies = { 'aklt/plantuml-syntax' },
    ft = 'plantuml',
    config = function()
      require('plantuml').setup {
        renderer = {
          type = 'imv',
          options = {
            dark_mode = false,
            format = nil, -- Allowed values: nil, 'png', 'svg'.
          },
        },
        render_on_write = true,
      }
    end,
  },
  -- {
  --   'https://gitlab.com/itaranto/preview.nvim',
  --   opts = {},
  --   config = function()
  --     vim.opt.spell = false
  --     -- vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
  --   end,
  -- },
  { 'NoahTheDuke/vim-just', ft = 'just', config = function() end },
  -- { 'nvim-neotest/nvim-nio' },
}
