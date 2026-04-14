return {
  cmd = { 'qmlls' },
  root_markers = { '.git' },
  filetypes = { 'qml' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
        },
      },
    },
  },
}
