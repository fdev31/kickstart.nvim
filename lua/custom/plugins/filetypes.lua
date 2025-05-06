return {
  {
    'aklt/plantuml-syntax',
    ft = 'plantuml',
    config = function()
      vim.opt.spell = false
      vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
    end,
  },
  {
    'https://gitlab.com/itaranto/plantuml.nvim',
    version = '*',
    config = function()
      require('plantuml').setup {
        renderer = {
          type = 'imv',
          options = {
            dark_mode = true,
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
