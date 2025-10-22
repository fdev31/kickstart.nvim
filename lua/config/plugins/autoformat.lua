-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[f]or[m]at buffer',
      },
      {
        '<leader>tF',
        function()
          local enabled = vim.g.conform_enabled
          if enabled then
            vim.g.conform_enabled = false
          else
            vim.g.conform_enabled = 'limited'
          end
          vim.notify(vim.g.conform_enabled and 'Selective autoformat ' or 'No autoformat')
        end,
        mode = '',
        desc = '[f]ormat',
      },
      {
        '<leader>tf',
        function()
          local enabled = vim.g.conform_enabled
          if enabled == 'limited' then
            vim.g.conform_enabled = true
          else
            vim.g.conform_enabled = 'limited'
          end
          vim.notify(vim.g.conform_enabled == true and 'Full autoformat ' or 'Selective autoformat')
        end,
        mode = '',
        desc = '[f]ormat',
      },
    },
    opts = vim.tbl_deep_extend('force', settings.conform_opts, {
      notify_on_error = true,
      notify_no_formatters = true,
      format_on_save = function(bufnr)
        if vim.g.conform_enabled == false then
          return
        end
        if vim.g.conform_enabled == nil or vim.g.conform_enabled == 'limited' then
          if require 'config.lib.partial_formatter'() ~= false then
            return
          end
        end
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = {} --  c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
    }),
  },
}
