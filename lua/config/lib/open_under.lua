local lib = require 'config.lib.core'
return function()
  -- Try LSP definition
  local params = vim.lsp.util.make_position_params()
  local result = vim.lsp.buf_request_sync(0, 'textDocument/definition', params, 500)

  if result and next(result) then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        -- Try type_definition first, if it doesn't work, fall back to definition
        local type_def_success = pcall(vim.lsp.buf.type_definition)
        if not type_def_success then
          vim.lsp.buf.definition()
        end
        return
      end
    end
  end
  local file_under_cursor = vim.fn.fnamemodify(vim.fn.expand '<cfile>', ':p')
  -- Check if the file exists and is readable
  if lib.file_exists(file_under_cursor) then
    vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
  else
    vim.notify('Could not find ' .. file_under_cursor, vim.log.levels.WARN)
  end
end
