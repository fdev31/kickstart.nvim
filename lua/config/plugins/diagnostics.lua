-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local lib = require 'config.lib.core'

local origin_map = {
  Harper = '  ',
  Ruff = '󱐋 ',
  typos = '󰓆  ',
  typescript = '󰛦  ', -- ts_ls
  ts = '󰛦  ', -- vts_ls
  ['Lua Diagnostics.'] = '  ',
}

local origin_patterns = {
  ['.*Harper.*'] = '  ',
}

local function get_origin_icon(source)
  -- Try exact match first
  if origin_map[source] then
    return origin_map[source]
  end

  -- Fall back to pattern matching
  for name, entry in pairs(origin_patterns) do
    if source:match(name) then
      return entry
    end
  end

  return nil -- or a default icon
end

local filter_diagnostics = function(diagnostics)
  -- Group by line number AND namespace to see all diagnostics together
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    local m = max_severity_per_line[d.lnum]
    -- Keep the diagnostic with lowest severity value (ERROR=1, WARN=2, etc.)
    if not m or d.severity < m.severity then
      max_severity_per_line[d.lnum] = d
    end
  end
  return vim.tbl_values(max_severity_per_line)
end

return {
  setup = function()
    -- INFO: Deduplicate Diagnostic icons by filtering at config level
    if settings.deduplicate_diagnostics then
      local ns = vim.api.nvim_create_namespace 'deduplicated_diagnostics'

      -- Create a wrapper around the original show function
      local orig_signs_handler = vim.diagnostic.handlers.signs

      vim.diagnostic.handlers.signs = {
        show = function(namespace, bufnr, diagnostics, opts)
          -- Get ALL diagnostics from ALL namespaces in the buffer
          local all_diagnostics = vim.diagnostic.get(bufnr, { namespace = nil })
          vim.tbl_extend('force', all_diagnostics, diagnostics)

          local filtered_diagnostics = filter_diagnostics(all_diagnostics)

          -- Hide from the incoming namespace first
          orig_signs_handler.hide(namespace, bufnr)
          orig_signs_handler.hide(ns, bufnr)

          -- Show filtered diagnostics in our deduplicated namespace
          orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
        end,

        hide = function(namespace, bufnr)
          orig_signs_handler.hide(namespace, bufnr)
          -- NOTE: makes things blink then disappear
          -- Also hide from our namespace to keep it clean
          -- orig_signs_handler.hide(ns, bufnr)
        end,
      }
    end
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
            -- Strip origin for newlines and blanks
            origin = lib.strip(origin)

            local icon = get_origin_icon(origin)
            if icon then
              prefix = icon
              origin = ''
            end

            local suffix = (origin and origin ~= '' and string.format(' (%s)', origin)) or ''
            return string.format('%s%s%s', prefix, diagnostic.message, suffix)
          end,
        })
      end,
    })

    vim.diagnostic.config(settings.diagnostic_config)
  end,
}
