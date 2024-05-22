local exported = {}

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

exported.has = function(tbl, item)
  for _, v in ipairs(tbl) do
    if v == item then
      return true
    end
  end
  return false
end

exported.isWorkLaptop = file_exists '/home/fab/liberty/code'

exported.isGitMergetool = vim.env.TEXTDOMAIN == 'git' or vim.env.GIT_PREFIX ~= nil

exported.useCopilot = true
exported.useCodeium = function()
  return not exported.isWorkLaptop
end

exported.border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

exported.ruff_rules = {
  'A',
  'AIR',
  'ANN',
  'ARG',
  'ASYNC',
  'B',
  'B',
  'BLE',
  'C',
  'C4',
  'C90',
  'COMFA',
  'D',
  'D',
  'DTZ',
  'E',
  'EM',
  'EXE',
  'F',
  'FBT',
  'FIX',
  'FLY',
  'G',
  'I',
  'ICN',
  'INP',
  'INT',
  'ISC',
  'LOG',
  'N',
  'PERF',
  'PIE',
  'PL',
  'PLC',
  'PLE',
  'PLR',
  'PLW',
  'PT',
  'PYI',
  'Q',
  'RET',
  'RSE',
  'RUF',
  'S',
  'SIM',
  'SLF',
  'SLOT',
  'T10',
  'TCH',
  'TD',
  'TID',
  'TRIO',
  'TRY',
  'UP',
  'W',
  'YTT',
}
exported.ruff_ignore = {
  'ANN002',
  'ANN003',
  'ANN101',
  'ANN102',
  'ANN204',
  'D105',
  'D107',
  'E203',
  'ISC001',
  'PLW0603',
  'PTH118',
  'RET503',
  'S101',
  'S311',
  'S404',
  'S602',
  'S603',
  'S605',
  'S607',
  'TID252',
}

exported.cmp_sources = {
  { group_index = 2, name = 'nvim_lsp' },
  { group_index = 2, name = 'luasnip' },
  { group_index = 2, name = 'path' },
}

if exported.useCopilot then
  table.insert(exported.cmp_sources, { group_index = 2, name = 'copilot' })
end

return exported
