local lib = require 'config.lib.core'

local function try_lsp_method(method, lsp_func, params)
  local result = vim.lsp.buf_request_sync(0, method, params, 1000)
  if result and next(result) then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        if pcall(lsp_func) then
          return true
        end
      end
    end
  end
  return false
end

return function()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')

  -- Try LSP methods in priority order
  local methods = {
    { name = 'textDocument/definition', handler = vim.lsp.buf.definition },
    { name = 'textDocument/typeDefinition', handler = vim.lsp.buf.type_definition },
    { name = 'textDocument/declaration', handler = vim.lsp.buf.declaration },
    { name = 'textDocument/implementation', handler = vim.lsp.buf.implementation },
  }

  for _, method in ipairs(methods) do
    if try_lsp_method(method.name, method.handler, params) then
      return
    end
  end

  -- Finally try to open as file name

  local file_under_cursor = vim.fn.fnamemodify(vim.fn.expand '<cfile>', ':p')
  -- Check if the file exists and is readable
  if lib.file_exists(file_under_cursor) then
    vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
  else
    vim.notify('Jump failed', vim.log.levels.WARN, { title = vim.fn.expand '<cfile>' })
  end
end
