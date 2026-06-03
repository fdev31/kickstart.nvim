local ih = require('config.lib.inlay_hints')

return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      hint = ih.for_lua_ls(),
    },
  },
}
