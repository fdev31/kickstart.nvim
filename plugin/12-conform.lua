-- vim:ts=2:sw=2:et:
-- SCHEDULE: autoformat (must be ready before first BufWritePre)
vim.schedule(function()
  local settings = require('config.settings')
  local lib = require('config.lib.core')

  vim.pack.add({
    'https://github.com/stevearc/conform.nvim',
  })

  local disable_filetypes = {}
  local _warned = false

  local options = {
    lsp_format = 'fallback',
    timeout_ms = 2000,
    async = true,
  }

  local FormatMode = {
    DISABLED = false,
    SELECTIVE = 'limited',
    FULL = true,
  }

  local get_default_value = function()
    if lib.is_buffer_tracked() then
      return FormatMode.SELECTIVE
    else
      return FormatMode.FULL
    end
  end

  local set_enabled = function(val)
    vim.b.conform_enabled = val
  end

  local get_format_mode = function()
    local enabled = vim.b.conform_enabled
    if enabled == nil then
      enabled = get_default_value()
    end
    return enabled
  end

  require('conform').setup(vim.tbl_deep_extend('force', settings.conform_opts, {
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = function(bufnr)
      local formatting_mode = get_format_mode()
      if formatting_mode == FormatMode.DISABLED then
        return
      end
      if formatting_mode == FormatMode.SELECTIVE then
        if require('config.lib.partial_formatter')() ~= false then
          return
        else
          if not _warned then
            _warned = true
            vim.notify("Selective formatting didn't work, proceeding with full format", 'info', { title = 'formatting' })
          end
        end
      end
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return vim.tbl_extend('keep', { async = false }, options)
      end
    end,
  }))

  -- Keymaps
  vim.keymap.set('', '<leader>fm', function()
    require('conform').format(options)
  end, { desc = '[f]or[m]at buffer' })

  vim.keymap.set('', '<leader>tF', function()
    local formatting_mode = get_format_mode()
    if formatting_mode ~= FormatMode.DISABLED then
      set_enabled(FormatMode.DISABLED)
    else
      set_enabled(get_default_value())
    end
    vim.notify(get_format_mode() and 'Selective autoformat ' or 'No autoformat')
  end, { desc = '[F]ormat' })

  vim.keymap.set('', '<leader>tf', function()
    if not lib.is_buffer_tracked() then
      vim.notify("File is untracked: can't enable selective formatting")
      return
    end
    local formatting_mode = get_format_mode()
    if formatting_mode == FormatMode.SELECTIVE then
      set_enabled(FormatMode.FULL)
    else
      set_enabled(get_default_value())
    end
    vim.notify(get_format_mode() == FormatMode.FULL and 'Full autoformat' or 'Selective autoformat')
  end, { desc = 'selective [f]ormat' })
end)
