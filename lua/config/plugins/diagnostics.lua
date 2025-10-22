-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

local origin_map = {
  Harper = ' ',
  Ruff = '󱐋 ',
  typos = '󰓆 ',
  typescript = '󰛦 ',
  ['Lua Diagnostics.'] = ' ',
}

-- Override the built-in signs handler
if settings.deduplicate_diagnostics then
  -- Create a custom namespace for aggregating signs
  local ns = vim.api.nvim_create_namespace 'my_diagnostic_namespace'

  -- Get a reference to the original signs handler
  local orig_signs_handler = vim.diagnostic.handlers.signs
  vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, _, opts)
      -- Get all diagnostics from the whole buffer
      local diagnostics = vim.diagnostic.get(bufnr)

      -- Find the "worst" (most severe) diagnostic per line
      local max_severity_per_line = {}
      for _, d in pairs(diagnostics) do
        local m = max_severity_per_line[d.lnum]
        if not m or d.severity < m.severity then
          max_severity_per_line[d.lnum] = d
        end
      end

      -- Pass the filtered diagnostics to the original handler
      local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
      orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,

    hide = function(_, bufnr)
      orig_signs_handler.hide(ns, bufnr)
    end,
  }
end

return {
  setup = function()
    -- INFO: vim.diagnostic.Opts
    vim.diagnostic.config(settings.diagnostic_config)
    -- INFO: show diagnostic after a delay
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
  end,
}
