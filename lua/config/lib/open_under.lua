local lib = require 'config.lib.core'
local lsp = require 'config.lib.lsp'

return function()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')

  -- Try LSP methods in priority order
  local methods = {
    { name = 'textDocument/definition', handler = vim.lsp.buf.definition },
    { name = 'textDocument/typeDefinition', handler = vim.lsp.buf.type_definition },
    { name = 'textDocument/declaration', handler = vim.lsp.buf.declaration },
    { name = 'textDocument/implementation', handler = vim.lsp.buf.implementation },
  }

  local clients = vim.lsp.get_clients { bufnr = 0 }

  for _, method in ipairs(methods) do
    if lsp.any_client_supports(method.name, { clients = clients }) then
      if lsp.try_method(method.name, method.handler, params) then
        return
      end
    end
  end

  -- Finally try to open as file name
  local filename = vim.fn.expand '<cfile>'

  local file_under_cursor = vim.fn.fnamemodify(filename, ':p')
  -- Check if the file exists and is readable
  if lib.file_exists(file_under_cursor) then
    vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
  else
    vim.notify('Jump failed', vim.log.levels.WARN, { title = filename })
  end
end
