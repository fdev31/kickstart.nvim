-- read ~/.onemw/config and extract the value of STB_IP

local function get_stb_ip()
  local file = io.open(os.getenv 'HOME' .. '/.onemw/config', 'r')
  if not file then
    return nil
  end
  for line in file:lines() do
    local key, value = line:match '^(STB_IP)=(.*)$'
    if key and value then
      file:close()
      return value
    end
  end
  file:close()
  return nil
end

local M = {
  useCopilot = true,
  useCodeium = true,
  border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  stb_ip = get_stb_ip(),
  diy_telescopes = {
    custom_actions = {
      command = function()
        local options = {
          { 'tox' },
          { cmd = '!scp "%" cra:/tmp', text = 'Scp cra' },
          { cmd = '!git diff "%" | wl-copy ', text = 'Copy diff' },
        }

        -- add text = command if text isn't defined + handle single strings {{{
        for _, command in ipairs(options) do
          -- if command is a string, make it an object
          if command[1] then
            command.command = command[1]
          end
          if not command.text then
            command.text = command.command or command.cmd
          end
        end -- }}}

        -- insert just commands {{{
        local just_targets = io.popen('just --list'):read '*a'
        local just_targets_list = vim.split(just_targets, '\n')
        -- append to the commands as "just <target name>" for text and command
        for i, target in ipairs(just_targets_list) do
          if i > 1 then
            -- strip starting and ending blanks
            target = target:gsub('[ \t\n]*$', ''):gsub('^[ \t\n]*', ''):gsub('[*].*$', '')
            if #target > 0 then
              table.insert(options, { text = 'just → ' .. target, command = 'just ' .. target })
            end
          end
        end
        -- }}}
        return options
      end,

      onSubmit = function(item)
        if vim.islist(item) then
          error 'Not support multiple selections'
        end
        -- RUN: cmd = vim cmd, command = terminal cmd (default) or handler = lua function {{{
        if item.cmd then
          vim.cmd(item.cmd)
        elseif item.command then
          vim.cmd('terminal ' .. item.command)
        elseif item.handler then
          item.handler()
        end -- }}}
      end,
    },
  },
  telescope_extensions = {
    aerial = {
      highlight_on_hover = true,
      highlight_on_closest = true,
      autojump = true,
      show_guides = true,
      -- Display symbols as <root>.<parent>.<symbol>
      show_nesting = {
        ['_'] = true, -- This key will be the default
        python = true,
        js = true,
      },
    },
  },
  cmp_sources = {
    { group_index = 2, name = 'nvim_lsp' },
    { group_index = 2, name = 'luasnip' },
    { group_index = 2, name = 'path' },
    { group_index = 2, name = 'copilot' },
    { group_index = 2, name = 'codeium' },
  },
  lspconfig_dependencies = {},
  cmp_dependencies = {},
  ruff_rules = {
    'A',
    'AIR',
    'ANN',
    'ARG',
    'ASYNC',
    'B',
    'B',
    -- "BLE",
    'C',
    'C4',
    'C90',
    'D',
    'D',
    'DTZ',
    'E',
    'EM',
    'EXE',
    'F',
    'FA',
    -- "FBT",
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
    'PT',
    'PYI',
    'Q',
    'RET',
    'RSE',
    'S',
    'SIM',
    'SLF',
    'SLOT',
    'T10',
    'TCH',
    'TD',
    'TID',
    'ASYNC1',
    'TRY',
    'UP',
    'W',
    'YTT',
  },
  ruff_ignore = {
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
  },
}
return M
