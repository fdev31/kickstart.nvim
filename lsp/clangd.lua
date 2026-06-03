local ih = require('config.lib.inlay_hints')

return {
  init_options = {
    InlayHints = ih.for_clangd(),
  },
}
