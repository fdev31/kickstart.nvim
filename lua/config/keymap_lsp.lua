return function(client, event)
  local lspmap = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc .. ' (lsp)' })
  end

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  lspmap('<leader>ca', vim.lsp.buf.code_action, 'Code [a]ctions', { 'n', 'x' })

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  lspmap('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  lspmap('gO', require('telescope.builtin').lsp_document_symbols, 'Open every Document Symbols')
  lspmap('go', function()
    require('telescope.builtin').lsp_document_symbols { symbols = { 'interface', 'class', 'method', 'function' } }
  end, 'Open Document Symbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  lspmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
    lspmap('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, 'Inlay [h]ints')
  end
end
