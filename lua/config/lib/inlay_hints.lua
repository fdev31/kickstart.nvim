-- Server-agnostic inlay hint configuration.
--
-- Presets live in config.settings.inlay_hints; this module resolves them and
-- adapts the generic flags to each LSP's native schema.
--
-- Add a new server by writing a small for_<server>(ft?) function below and
-- consuming it from the matching lsp/<server>.lua.

local M = {}

---Resolve the active preset for a given filetype into a normalized table.
---@param ft string|nil
---@return table
local function resolve(ft)
  local s = require('config.settings').inlay_hints or {}
  local pick = (s.by_filetype or {})[ft] or s.preset
  local p = (type(pick) == 'table' and pick)
    or (s.presets and s.presets[pick])
    or {}

  local pn = p.parameter_names
  if pn == true then
    pn = 'all'
  end
  if pn == nil or pn == false then
    pn = 'none'
  end

  return {
    parameter_names = pn, -- 'none' | 'literals' | 'all'
    parameter_types = p.parameter_types or false,
    variable_types  = p.variable_types or false,
    return_types    = p.return_types or false,
    property_types  = p.property_types or false,
    enum_values     = p.enum_values or false,
    extras          = p.extras or false,
  }
end

---vtsls / tsserver — used for both typescript and javascript settings keys.
function M.for_vtsls(ft)
  local p = resolve(ft)
  return {
    parameterNames = { enabled = p.parameter_names },
    parameterTypes = { enabled = p.parameter_types },
    variableTypes = {
      enabled = p.variable_types,
      suppressWhenTypeMatchesName = true,
    },
    propertyDeclarationTypes = { enabled = p.property_types },
    functionLikeReturnTypes  = { enabled = p.return_types },
    enumMemberValues         = { enabled = p.enum_values },
  }
end

---lua-language-server — consumed as settings.Lua.hint
function M.for_lua_ls()
  local p = resolve('lua')
  local pn = ({ none = 'Disable', literals = 'Literal', all = 'All' })[p.parameter_names]
  return {
    enable     = p.parameter_names ~= 'none' or p.variable_types or p.parameter_types,
    paramName  = pn,
    paramType  = p.parameter_types,
    setType    = p.variable_types,
    arrayIndex = p.extras and 'Enable' or 'Disable',
    await      = p.extras,
  }
end

---clangd — consumed as init_options.InlayHints (clangd 14+)
function M.for_clangd()
  local p = resolve('cpp')
  return {
    Enabled        = p.parameter_names ~= 'none' or p.variable_types,
    ParameterNames = p.parameter_names ~= 'none',
    DeducedTypes   = p.variable_types or p.return_types,
    Designators    = p.extras,
    BlockEnd       = p.extras,
  }
end

---ty (Astral) — consumed as settings.ty.inlayHints
---Schema is young upstream; revisit if hints don't render.
function M.for_ty()
  local p = resolve('python')
  return {
    variableTypes          = p.variable_types,
    callArgumentNames      = p.parameter_names ~= 'none',
    callArgumentNamesStyle = (p.parameter_names == 'literals') and 'literals' or 'all',
  }
end

M.resolve = resolve
return M
