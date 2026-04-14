local M = {}

--- removes consecutive spaces and stops at the first 0 (^@) character.
M.clean_string = function(text, maxlen)
  local cleaned = text:gsub('%s+', ' ')
  local null_pos = cleaned:find '%z'
  if null_pos then
    cleaned = cleaned:sub(1, null_pos - 1)
  end
  if maxlen and #cleaned > maxlen then
    cleaned = cleaned:sub(1, maxlen - 3) .. '…'
  end
  return cleaned
end

M.is_buffer_tracked = function()
  local file_path = vim.fn.expand '%:p'
  if file_path == '' then
    return false
  end

  -- Use fugitive to check if file is tracked
  local status = vim.fn.FugitiveStatusline()
  -- If the file is not tracked, status would typically be empty or indicate untracked
  return status ~= '' and not status:match '%%%-' -- %- indicates untracked
end

M.strip = function(origin)
  return origin:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', ' ')
end

-- partial function supports think "functools.partial" in python
M.partial = function(fn, ...)
  local args = { ... }
  return function(...)
    local combined_args = {}
    for i, v in ipairs(args) do
      combined_args[i] = v
    end
    for i, v in ipairs { ... } do
      combined_args[#args + i] = v
    end
    return fn(unpack(combined_args))
  end
end

M.file_exists = function(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
