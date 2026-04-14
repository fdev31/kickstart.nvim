local ruff = require('config.ruff_rules')
return {
  formatEnabled = true,
  rules = ruff.rules,
  ignore = ruff.ignore,
}
