return {
  handlers = {
    -- Silently stop the client when no ESLint library is found in the project,
    -- instead of showing a warning on every buffer open.
    ['eslint/noLibrary'] = function(_, _, ctx)
      vim.lsp.stop_client(ctx.client_id, true)
      return {}
    end,
  },
}
