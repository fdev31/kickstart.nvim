return {
  {
    'aklt/plantuml-syntax',
    ft = 'plantuml',
    config = function()
      vim.opt.spell = false
      vim.api.nvim_set_hl(0, 'PlantumlColonLine', { link = '@character' })
    end,
  },
  { 'NoahTheDuke/vim-just', ft = 'just', config = function() end },
  -- { 'nvim-neotest/nvim-nio' },
}
