local vue_path = vim.fn.stdpath('data')
  .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

local ih = require('config.lib.inlay_hints')

return {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  settings = {
    vtsls = {
      tsserver = {
        -- Bump memory for large monorepos (e.g. onemw-js)
        maxTsServerMemory = 8192,
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_path,
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
    typescript = { inlayHints = ih.for_vtsls('typescript') },
    javascript = { inlayHints = ih.for_vtsls('javascript') },
  },
}
