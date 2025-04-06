-- NOTE:
-- cmd: is for vim commands
-- command: will run in terminal
-- handler: will run lua function

local enable_just = false

local options = {
  {
    text = ' Compare',
    cmd = 'Compare',
  },
  { text = '→ Scp cra', cmd = '!scp "%" cra:/tmp' },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy ' },
  {
    text = ' Git add',
    cmd = '!git add "%"',
  },
  {
    text = ' Git reset',
    cmd = '!git reset HEAD "%"',
  },
  {
    text = ' Git buffer commit history',
    handler = function()
      require('telescope.builtin').git_bcommits()
    end,
  },
}

local M = {
  custom_actions = {
    command = function()
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
      if enable_just then
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
}
return M
