return {
  { 'fdev31/menus.nvim', event = 'VeryLazy', dependencies = { 'nvim-telescope/telescope.nvim', 'folke/snacks.nvim' } }, -- menus
  { 'stevearc/overseer.nvim', cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerOpen' } }, -- detect workspace's runnables, used in menus.lua
}
