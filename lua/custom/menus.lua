-- NOTE:
-- cmd: (str) is for vim commands
-- command: (str) will run in terminal
-- handler: (function) will run lua code

local M = {}

local builtin = require 'telescope.builtin'

local git_menu = { --{{{
  {
    text = ' Compare to (diffView) ▶',
    cmd = 'Compare',
  },
  {
    text = ' file history',
    handler = builtin.git_bcommits,
  },
  {
    text = ' line history',
    handler = package.loaded.snacks.picker.git_log_line,
  },
  {
    text = ' Add file',
    cmd = '!git add "%"',
  },
  {
    text = ' Reset file',
    cmd = '!git reset HEAD "%"',
  },
  {
    text = '⏬Checkout branch',
    handler = package.loaded.snacks.picker.git_branches,
  },
} -- }}}

M.main_menu = {
  {
    text = ' Git ▶',
    options = git_menu,
  },
  { text = ' Silicon', cmd = 'Silicon' },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy' },
  { text = '→ Scp cra', cmd = '!scp "%" cra:/tmp' },
}

return M
