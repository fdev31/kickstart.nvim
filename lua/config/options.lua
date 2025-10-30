-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local setup = function()
  vim.g.mapleader = settings.leader
  vim.g.maplocalleader = settings.leader
  vim.g.have_nerd_font = settings.use_nerd_font

  -- hide command bar when not needed
  vim.o.cmdheight = 0
  -- Enable break indent
  vim.o.breakindent = true

  -- Break on word boundaries
  vim.o.linebreak = true
  vim.o.wrap = false

  -- Save undo history
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes:2'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = false

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-options-guide`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = false

  vim.g.conform_enabled = 'limited'
  vim.o.spell = true
  vim.o.spelllang = 'en_us'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldtext = 'getline(v:foldstart)'
  vim.o.wmh = 0

  vim.o.sw = 4
  vim.o.ts = 4
  vim.o.et = true
  -- vim.o.fdm = 'marker'
  vim.o.foldmethod = 'manual'
  vim.o.autoread = true
  vim.o.number = false

  vim.o.backup = false
  vim.o.swapfile = false
  vim.o.writebackup = false

  vim.o.foldenable = false
  vim.o.termguicolors = true

  -- vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false

  local _diffopt = {
    'internal',
    -- 'iwhiteall',
    'filler',
    'closeoff',
    'algorithm:histogram',
    'indent-heuristic',
    'linematch:60',
    'vertical',
    'foldcolumn:1',
    'hiddenoff',
  }
  local diffopt = vim.opt.diffopt:get()
  -- if not vim.tbl_contains(diffopt, 'algorithm:patience') then
  --   vim.opt.diffopt:append 'algorithm:patience'
  -- end
  -- add each diff opt
  for _, opt in pairs(_diffopt) do
    if not vim.tbl_contains(diffopt, opt) then
      vim.opt.diffopt:append(opt)
    end
  end
end
return {
  setup = setup,
}
