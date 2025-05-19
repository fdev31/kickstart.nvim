local lib = require 'custom.lib'

local origin_map = {
  Harper = ' ',
  Ruff = '󱐋 ',
}
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    -- FIXME: commented out because it seems to prevent some tips to show
    -- if lib.floating_win_exists() then
    --   return
    -- end
    vim.diagnostic.open_float(nil, {
      scope = 'line',
      header = '',
      format = function(diagnostic)
        local origin = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.source or ''
        local prefix = '󰄳 '

        -- strip origin for newlines and blanks
        origin = origin:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')
        local sub = origin_map[origin]
        if sub then
          prefix = sub
          origin = ''
        end

        if origin and origin ~= '' then
          origin = string.format(' (%s)', origin)
        else
          origin = ''
        end

        return string.format('%s%s%s', prefix, diagnostic.message, origin)
      end,
    })
  end,
})

return {}
