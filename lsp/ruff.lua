local ruff = require('config.ruff_rules')
return {
  settings = {
    formatEnabled = true,
    rules = ruff.rules,
    ignore = ruff.ignore,
  },
}
