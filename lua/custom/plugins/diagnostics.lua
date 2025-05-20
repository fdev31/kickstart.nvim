local lib = require 'custom.lib'
local settings = require 'custom.settings'

local origin_map = {
  Harper = ' ',
  Ruff = '󱐋 ',
  typos = '󰓆 ',
  typescript = '󰛦 ',
  ['Lua Diagnostics.'] = ' ',
}

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    if not settings.showDiagnostics then
      return
    end
    -- FIXME: commented out because it seems to prevent some tips to show
    -- if lib.floating_win_exists() then
    --   return
    -- end
    _, settings._diag_window = vim.diagnostic.open_float(nil, {
      scope = 'line',
      header = '',
      format = function(diagnostic)
        local prefix = '󰄳 '
        local origin = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.source or ''
        -- strip origin for newlines and blanks
        origin = origin:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')

        if origin_map[origin] then
          prefix = origin_map[origin]
          origin = ''
        end

        local suffix = (origin and origin ~= '' and string.format(' (%s)', origin)) or ''

        return string.format('%s%s%s', prefix, diagnostic.message, suffix)
      end,
    })
  end,
})

return {}
