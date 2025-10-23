local M = {}

--- Check if any attached client supports the method
---@param method string The LSP method to check (e.g., 'textDocument/definition').
---@param opts table Optional parameters
---@field opts.bufnr? number The buffer number to check clients for. Defaults to current buffer (0).
---@field opts.clients? table A list of LSP clients to check. If not provided, it retrieves clients attached to the specified buffer.
---@return boolean True if any client supports the method, false otherwise.
M.any_client_supports = function(method, opts)
  local bufnr = opts.bufnr or 0

  local clients = opts.clients
  if not clients then
    clients = vim.lsp.get_clients { bufnr = bufnr }
  end

  for _, client in ipairs(clients) do
    if client.supports_method(method, { bufnr = bufnr }) then
      return true
    end
  end
  return false
end

--- Try to call an LSP method and execute a function if successful
--- @param method string The LSP method to call (e.g., 'textDocument/definition').
--- @param func function The function to execute if the LSP method returns results.
--- @param params table The parameters to pass to the LSP method.
--- @return boolean True if the function was executed, false otherwise.

M.try_method = function(method, func, params)
  local result = vim.lsp.buf_request_sync(0, method, params, 1000)
  if result and next(result) then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        if pcall(func) then
          return true
        end
      end
    end
  end
  return false
end

return M
