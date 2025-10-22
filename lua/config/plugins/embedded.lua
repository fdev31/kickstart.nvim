-- vim:ts=2:sw=2:et:
return {
  {
    'anurag3301/nvim-platformio.lua',
    event = 'VeryLazy',
    dependencies = {
      { 'akinsho/nvim-toggleterm.lua' },
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
  },
}
