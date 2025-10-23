-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local lib = require 'config.lib.core'

local origin_map = {
  Harper = ' ',
  Ruff = '󱐋 ',
  typos = '󰓆 ',
  typescript = '󰛦 ',
  ['Lua Diagnostics.'] = ' ',
}
return {
  setup = function()
    -- INFO: vim.diagnostic.Opts
    vim.diagnostic.config(settings.diagnostic_config)
    -- INFO: DE duplicate Diagnostic icons by overriding the built-in signs handler
    if settings.deduplicate_diagnostics then
      local orig_signs_handler = vim.diagnostic.handlers.signs

      -- Replace the signs handler with our custom implementation
      vim.diagnostic.handlers.signs = {
        show = function(namespace, bufnr, diagnostics, opts)
          -- Return early if there are no diagnostics
          if not diagnostics or #diagnostics == 0 then
            return orig_signs_handler.show(namespace, bufnr, {}, opts)
          end

          -- Find the "worst" (most severe) diagnostic per line
          local max_severity_per_line = {}
          for _, d in ipairs(diagnostics) do
            -- Skip diagnostics without line numbers
            if d.lnum ~= nil then
              local line = d.lnum

              -- Initialize with current diagnostic if line not seen before
              if not max_severity_per_line[line] then
                max_severity_per_line[line] = d
              else
                -- Compare severities, handling missing severity values
                local current_severity = d.severity or vim.diagnostic.severity.HINT
                local existing_severity = max_severity_per_line[line].severity or vim.diagnostic.severity.HINT

                -- Lower severity values are more severe in Neovim (1=ERROR, 2=WARN, etc.)
                if current_severity < existing_severity then
                  max_severity_per_line[line] = d
                end
              end
            end
          end

          -- Convert the filtered diagnostics back to a list
          local filtered_diagnostics = {}
          for _, diagnostic in pairs(max_severity_per_line) do
            table.insert(filtered_diagnostics, diagnostic)
          end

          -- Call the original handler with filtered diagnostics
          orig_signs_handler.show(namespace, bufnr, filtered_diagnostics, opts)
        end,

        hide = function(namespace, bufnr)
          orig_signs_handler.hide(namespace, bufnr)
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
