return {
  {
    'michaelrommel/nvim-silicon', -- nice code screenshots
    lazy = true,
    cmd = 'Silicon',
    opts = {
      --      disable_defaults = true,
      to_clipboard = true,
      output = '/tmp/code.png',
      --      background = '#212131',
      tab_width = 2,
      theme = 'gruvbox-dark',
      font = 'Fira Code',
      shadow_blur_radius = 7,
      pad_horiz = 30,
      pad_vert = 30,
      shadow_color = '#100000',
      background_image = '/home/fab/Images/code-bg.jpg',
    },
  },
}
