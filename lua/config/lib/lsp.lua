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

--- Deduplicate and handle LSP location results.
--- If a single unique result, jump directly. Otherwise open the quickfix list.
---@param options table The on_list options from vim.lsp.buf (has .items and .title)
M.dedup_on_list = function(options)
  local seen = {}
  local items = {}
  for _, item in ipairs(options.items) do
    local key = item.filename .. ':' .. item.lnum .. ':' .. item.col
    if not seen[key] then
      seen[key] = true
      items[#items + 1] = item
    end
  end
  if #items == 1 then
    local item = items[1]
    vim.cmd('edit ' .. vim.fn.fnameescape(item.filename))
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
  else
    vim.fn.setqflist({}, ' ', { title = options.title, items = items })
    vim.cmd('copen')
  end
end

--- Try to call an LSP method synchronously and check if it has results.
--- If results exist, call the handler with on_list deduplication.
--- @param method string The LSP method to call (e.g., 'textDocument/definition').
--- @param handler function The vim.lsp.buf function to call (e.g., vim.lsp.buf.definition).
--- @param params table The position params for the sync probe.
--- @return boolean True if the method returned results, false otherwise.
M.try_method = function(method, handler, params)
  local result = vim.lsp.buf_request_sync(0, method, params, 1000)
  if result and next(result) then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        handler { on_list = M.dedup_on_list }
        return true
      end
    end
  end
  return false
end

return M
