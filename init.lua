vim.loader.enable()

require('config.options').setup()
pcall(require, 'config.custom')

-- Monkey-patch vim.pack.add so every spec defaults to confirm=false
-- (skip the interactive confirmation prompt on first install).
--
-- This must run before any other module calls vim.pack.add — i.e. before
-- the plugin/ directory is auto-sourced. Any code that captures a reference
-- to vim.pack.add before this block executes will bypass the patch.
do
  local orig_add = vim.pack.add
  vim.pack.add = function(specs, opts)
    opts = vim.tbl_extend('keep', opts or {}, { confirm = false })
    return orig_add(specs, opts)
  end
end

-- Everything else is handled by plugin/ directory (auto-sourced alphabetically)
-- vim: ts=2 sts=2 sw=2 et
