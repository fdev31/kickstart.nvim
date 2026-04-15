-- Work-specific STB (set-top box) remote debug configurations.
-- Loaded conditionally from plugin/42-daps.lua via pcall.
local M = {}

local _stb_ip = nil
local function get_stb_ip()
  if _stb_ip then return _stb_ip end
  local file = io.open(os.getenv('HOME') .. '/.onemw/config', 'r')
  if not file then return nil end
  for line in file:lines() do
    local key, value = line:match('^(STB_IP)=(.*)$')
    if key and value then
      file:close()
      _stb_ip = value
      return value
    end
  end
  file:close()
  return nil
end

--- Return STB-specific DAP configurations for JavaScript/TypeScript.
--- @return table[] List of DAP configuration entries
function M.configurations()
  return {
    {
      name = 'Attach to AS',
      type = 'pwa-node',
      request = 'attach',
      address = get_stb_ip(),
      port = 9230,
      remoteRoot = '/usr/share/lgias/app/',
      cwd = '${workspaceFolder}',
      localRoot = '${workspaceFolder}',
      skipFiles = { '<node_internals>/**' },
      stopOnEntry = true,
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
    {
      name = 'Attach to JSAPP',
      type = 'pwa-node',
      request = 'attach',
      address = get_stb_ip(),
      port = 9229,
      remoteRoot = '/usr/share/lgioui/app/',
      cwd = '${workspaceFolder}',
      localRoot = '${workspaceFolder}',
      skipFiles = { '<node_internals>/**' },
      stopOnEntry = true,
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
  }
end

return M
