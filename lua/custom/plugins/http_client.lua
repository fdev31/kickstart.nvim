return {
  {
    'mistweaverco/kulala.nvim',
    ui = { formatter = true },
    keys = {
      { 's', desc = 'Send request' },
      { 'a', desc = 'Send all requests' },
      { 'b', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    opts = {
      -- your configuration comes here
      global_keymaps = true,
      global_keymaps_prefix = '<leader>R',
      kulala_keymaps_prefix = '',
    },
  },
}
