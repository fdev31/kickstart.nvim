vim.loader.enable()
require('config.options').setup()
pcall(require, 'config.custom')
-- Everything else is handled by plugin/ directory (auto-sourced alphabetically)
-- vim: ts=2 sts=2 sw=2 et
