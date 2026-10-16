-- vim:ts=2:sw=2:et:
-- ON_KEY: file tree browser (loads on <C-n>)
local loaded = false

local function load_neotree()
  if loaded then return end
  loaded = true

  vim.pack.add({
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
  })

  local events = require('neo-tree.events')
  local function on_move(data)
    Snacks.rename.on_rename_file(data.source, data.destination)
  end

  require('neo-tree').setup({
    log_level = 'error',
    filesystem = {
      window = {
        mappings = {
          ['<C-n>'] = 'close_window',
          ['<leader>+'] = 'git_add_file',
          ['<leader>-'] = 'git_unstage_file',
          ['p'] = {
            'toggle_preview',
            config = { use_float = false },
          },
        },
      },
    },
    event_handlers = {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    },
  })
end

vim.keymap.set('n', '<C-n>', function()
  load_neotree()
  vim.cmd('Neotree reveal')
end, { desc = 'NeoTree reveal', silent = true })
