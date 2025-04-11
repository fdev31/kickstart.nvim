local M = {}

local telescope = require 'telescope.builtin'

local openDiffView = function(_, action)
  action('i', '<CR>', function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    vim.cmd('DiffviewOpen ' .. selection.value .. '...HEAD --imply-local')
  end)
  return true
end

local openDiffViewMB = function(_, action)
  action('i', '<CR>', function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    local result = vim.fn.system('git merge-base HEAD ' .. selection.value)
    local merge_base = result:gsub('%s+', '')
    vim.cmd('DiffviewOpen ' .. merge_base .. '...HEAD --imply-local')
  end)
  return true
end

M.git_compare_what = {
  {
    text = 'branch',
    handler = function()
      require('telescope.builtin').git_branches { attach_mappings = openDiffView }
    end,
  },
  {
    text = 'commit',
    handler = function()
      telescope.git_commits { attach_mappings = openDiffView }
    end,
  },
  {
    text = 'branch "merge base" (PR like)',
    handler = function()
      telescope.git_branches { attach_mappings = openDiffViewMB }
    end,
  },
}

M.git_menu = { --{{{
  {
    text = ' Commit',
    handler = function()
      require('diffview').close()
      vim.cmd ':terminal git commit'
      vim.cmd ':startinsert'
    end,
  },
  {
    text = '󱖫 Status',
    handler = package.loaded.snacks.picker.git_status,
    -- handler = builtin.git_status,
  },
  {
    text = ' Cached',
    command = 'git diff --cached',
  },
  {
    text = ' Compare to (DiffView) ▶',
    options = M.git_compare_what,
  },
  {
    text = ' file history',
    handler = telescope.git_bcommits,
  },
  {
    text = ' line history',
    handler = package.loaded.snacks.picker.git_log_line,
  },
  {
    text = ' Add file',
    cmd = '!git add "%"',
  },
  {
    text = ' Reset file',
    cmd = '!git reset HEAD "%"',
  },
  {
    text = '⏬Checkout branch',
    handler = telescope.git_branches,
  },
} -- }}}

M.main_menu = {
  {
    text = ' Git ▶',
    options = M.git_menu,
  },
  { text = ' DiffView Open', cmd = 'DiffviewOpen' },
  { text = ' DiffView Close', cmd = 'DiffviewClose' },
  { text = ' Silicon', cmd = "'<,'> Silicon" },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy' },
  { text = '→ Scp cra', cmd = '!scp "%" cra:/tmp' },
}

return M
