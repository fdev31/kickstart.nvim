-- vim:ts=2:sw=2:et:
-- EAGER: statusline must be visible at startup
local lib = require('config.lib.core')

local _precise_render_statusline = function(location)
  local get_node = vim.treesitter.get_node
  local ok, node = pcall(get_node)

  local first = true
  if ok and node then
    while node do
      local name_node = node:field('name')[1]
      if name_node then
        local func_name = lib.clean_string(vim.treesitter.get_node_text(name_node, 0), 20)
        if first then
          location = func_name .. '┃ ' .. location
          first = false
        else
          location = func_name .. '.' .. location
        end
      end
      node = node:parent()
    end
    return location
  end
end

local render_statusline = function()
  local location = '%2l:%-2v'
  local _, ret = pcall(_precise_render_statusline, location)
  return ret or location
end

vim.pack.add({
  'https://github.com/echasnovski/mini.nvim',
})

vim.api.nvim_set_hl(0, 'MiniCursorword', { link = 'LspReferenceText' })
require('mini.cursorword').setup({ delay = 300 })
require('mini.align').setup({
  mappings = {
    start = '',
    start_with_preview = 'gA',
  },
})

local statusline = require('mini.statusline')
statusline.setup({ use_icons = vim.g.have_nerd_font })
statusline.section_location = render_statusline
