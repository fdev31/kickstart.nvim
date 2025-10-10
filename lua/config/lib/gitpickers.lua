local telescope = require 'telescope.builtin'
local M = {}

DIFF_COMMAND = 'DiffviewOpen'

M.set_diff_command = function(cmd)
  DIFF_COMMAND = cmd
end

-- Custom menu functions

local function _telescope(callback)
  return function(_, action)
    action('i', '<CR>', function(prompt_bufnr)
      local selection = require('telescope.actions.state').get_selected_entry()
      require('telescope.actions').close(prompt_bufnr)
      callback(selection)
    end)
    return true
  end
end

M.cherryPickCommitsFromBranch = _telescope(function(selection)
  telescope.git_commits {
    branch = selection.value,
    attach_mappings = _telescope(function(commit)
      vim.cmd('Git cherry-pick ' .. commit.value .. ' -x')
    end),
  }
end)

M.openDiffView = _telescope(function(selection)
  vim.cmd(DIFF_COMMAND .. ' ' .. selection.value)
end)

M.openDiffViewMB = _telescope(function(selection)
  local result = vim.fn.system('git merge-base HEAD ' .. selection.value)
  local merge_base = result:gsub('%s+', '')
  vim.cmd(DIFF_COMMAND .. ' ' .. merge_base)
end)

return M
