# LSP Server Configurations

This directory contains per-server configuration files for Neovim's native
`vim.lsp.config()` (0.11+).

## Why do empty files exist?

`mason-lspconfig.nvim` v2 with `automatic_enable = true` requires a
corresponding `lsp/<server>.lua` file for each server it should auto-enable
via `vim.lsp.enable()`. Servers without a file here will be installed by Mason
but **not** automatically started.

Files that return just `return {}` use the server's defaults — they exist
solely to opt the server into automatic enablement.
