return function()
  -- Try LSP definition
  local result = vim.lsp.buf_request_sync(0, 'textDocument/definition', vim.lsp.util.make_position_params(), 500)

  if result and next(result) then
    for _, res in pairs(result) do
      if res.result and #res.result > 0 then
        return vim.lsp.buf.definition()
      end
    end
  end
  local file_under_cursor = vim.fn.fnamemodify(vim.fn.expand '<cfile>', ':p')
  -- Check if the file exists and is readable
  if M.file_exists(file_under_cursor) then
    vim.cmd('edit ' .. vim.fn.fnameescape(file_under_cursor))
  else
    vim.notify('Could not find ' .. file_under_cursor, vim.log.levels.WARN)
  end
end
