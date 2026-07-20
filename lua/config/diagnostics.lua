-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
local lib = require 'config.lib.core'

local origin_map = {
  Harper = '  ',
  Ruff = '󱐋 ',
  typos = '󰓆  ',
  typescript = '󰛦  ', -- ts_ls
  ts = '󰛦  ', -- vts_ls
  ['Lua Diagnostics.'] = '  ',
}

local origin_patterns = {
  ['.*Harper.*'] = '  ',
}

local function get_origin_icon(source)
  -- Try exact match first
  if origin_map[source] then
    return origin_map[source]
  end

  -- Fall back to pattern matching
  for pattern, icon in pairs(origin_patterns) do
    if source:match(pattern) then
      return icon
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

    local dedup_ns = vim.api.nvim_create_namespace 'deduplicated_diagnostics'
    local orig_signs_handler = vim.diagnostic.handlers.signs
    local new_signs_handler = {
      show = function(namespace, bufnr, diagnostics, opts)
        if not settings.deduplicate_diagnostics and settings.showDiagnostics then
          return orig_signs_handler.show(namespace, bufnr, diagnostics, opts)
        end
        -- Get ALL diagnostics from ALL namespaces in the buffer
        local all_diagnostics = vim.diagnostic.get(bufnr)

        local filtered_diagnostics = filter_diagnostics(all_diagnostics)

        -- Hide from the incoming namespace first
        orig_signs_handler.hide(namespace, bufnr)
        orig_signs_handler.hide(dedup_ns, bufnr)

        -- Show filtered diagnostics in our deduplicated namespace
        if settings.showDiagnostics then
          orig_signs_handler.show(dedup_ns, bufnr, filtered_diagnostics, opts)
        end
      end,

      hide = function(namespace, bufnr)
        orig_signs_handler.hide(namespace, bufnr)
        -- Re-render dedup signs with remaining diagnostics
        orig_signs_handler.hide(dedup_ns, bufnr)
        if settings.showDiagnostics then
          local remaining = vim.diagnostic.get(bufnr)
          if #remaining > 0 then
            local filtered = filter_diagnostics(remaining)
            orig_signs_handler.show(dedup_ns, bufnr, filtered, vim.diagnostic.config() or {})
          end
        end
      end,
    }

    vim.diagnostic.handlers.signs = new_signs_handler

    -- Namespace used only for the deduped float; no gutter/virtual-text side-effects.
    local float_ns = vim.api.nvim_create_namespace 'diag_float_dedup'
    vim.diagnostic.config({ signs = false, virtual_text = false, underline = false }, float_ns)

    local function format_diagnostic(diagnostic)
      local prefix = '󰄳 '
      local origin = diagnostic.source or ''
      origin = lib.strip(origin)
      local icon = get_origin_icon(origin)
      if icon then
        prefix = icon
        origin = ''
      end
      local suffix = (origin and origin ~= '' and string.format(' (%s)', origin)) or ''
      return string.format('%s%s%s', prefix, diagnostic.message, suffix)
    end

    -- INFO: show diagnostic after a delay
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = function()
        if not settings.showDiagnostics then
          return
        end
        -- Don't open the diagnostic float if another floating window is
        -- already open (e.g. LSP hover via `K`), otherwise it would clobber it.
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= '' then
            return
          end
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
        local all = vim.diagnostic.get(bufnr, { lnum = lnum })
        if #all == 0 then
          return
        end

        -- Deduplicate by message text across all clients/namespaces.
        local seen, deduped = {}, {}
        for _, d in ipairs(all) do
          if not seen[d.message] then
            seen[d.message] = true
            deduped[#deduped + 1] = d
          end
        end

        -- Populate the silent namespace and open the float from it only.
        -- set + reset happen in the same synchronous callback so the UI
        -- never sees the intermediate gutter state.
        vim.diagnostic.set(float_ns, bufnr, deduped)
        _, settings._diag_window = vim.diagnostic.open_float(nil, {
          namespace = float_ns,
          scope = 'line',
          header = '',
          format = format_diagnostic,
        })
        vim.diagnostic.reset(float_ns, bufnr)
      end,
    })

    vim.diagnostic.config(settings.diagnostic_config)
  end,
}
