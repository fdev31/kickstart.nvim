-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local codesnap = {
  'mistricky/codesnap.nvim',
  build = 'make',
  command = {
    'Codesnap',
    'CodesnapSave',
    'CodeSnapASCII',
    'CodeSnapHighlight',
    'CodeSnapSaveHighlight',
  },
  opts = {
    save_path = '/tmp',
    show_workspace = false,
    code_font_family = 'Fira Code',
    title = 'x',
  },
}
local silicon = {
  'michaelrommel/nvim-silicon', -- nice code screenshots
  lazy = true,
  cmd = 'Silicon',
  opts = {
    --      disable_defaults = true,
    to_clipboard = true,
    output = '/tmp/code.png',
    --      background = '#212131',
    tab_width = 2,
    theme = 'Dracula',
    font = 'Fira Code',
    shadow_blur_radius = 7,
    pad_horiz = 30,
    pad_vert = 30,
    shadow_color = '#100000',
    -- background_image = '/home/fab/Images/code-bg.jpg',
  },
}

if settings.snapshots == 'codesnap' then
  return {
    codesnap,
  }
else
  return {
    silicon,
  }
end
