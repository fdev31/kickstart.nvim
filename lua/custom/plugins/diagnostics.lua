local lib = require 'custom.lib'
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      source = 'if_many',

      format = function(diagnostic)
        local origin = diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.source or ''
        local prefix = ''

        if origin == 'Harper' then
          prefix = '  '
          origin = ''
        else
          if diagnostic.code then
            local safe_code = lib.safeString(diagnostic.code)
            origin = string.format('%s %s', origin, safe_code)
          else
            origin = nil
          end
          origin = origin and string.format('🯖%s', origin) or ''
        end

        -- strip origin for newlines and blanks
        origin = origin:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')
        return string.format('%s%s%s', prefix, diagnostic.message, origin)
      end,
    })
  end,
})

return {}
