vim.loader.enable()

require('config.options').setup()
pcall(require, 'config.custom')

-- Auto-accept plugin installations (skip confirmation prompt)
do
  local orig_add = vim.pack.add
  vim.pack.add = function(specs, opts)
    opts = vim.tbl_extend('keep', opts or {}, { confirm = false })
    return orig_add(specs, opts)
  end
end

-- Everything else is handled by plugin/ directory (auto-sourced alphabetically)
-- vim: ts=2 sts=2 sw=2 et
