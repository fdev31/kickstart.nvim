return {
  on_attach = function(client)
    -- ty v0.0.30 misclassifies imported/used functions as "variable" in semantic tokens;
    -- disable until upstream fixes this, let treesitter handle highlighting instead
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
