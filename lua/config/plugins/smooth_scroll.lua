-- vim:ts=2:sw=2:et:
return {
  {
    'karb94/neoscroll.nvim', -- animated scroll
    event = 'VeryLazy',
    opts = {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        '<C-u>',
        '<C-d>',
        '<C-b>',
        '<C-f>',
        '<C-y>',
        '<C-e>',
        'zt',
        'zz',
        'zb',
      },
      hide_cursor = false, -- Hide cursor while scrolling
      respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      duration_multiplier = 0.5, -- Global duration multiplier
      easing = 'sine', -- Default easing function
    },
  },
}
