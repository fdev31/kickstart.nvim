local M = {}

local telescope = require 'telescope.builtin'

local openDiffView = function(_, action)
  action('i', '<CR>', function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    vim.cmd('DiffviewOpen -uno ' .. selection.value .. '...HEAD --imply-local')
  end)
  return true
end

local openDiffViewMB = function(_, action)
  action('i', '<CR>', function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    local result = vim.fn.system('git merge-base HEAD ' .. selection.value)
    local merge_base = result:gsub('%s+', '')
    vim.cmd('DiffviewOpen -uno ' .. merge_base .. '...HEAD --imply-local')
  end)
  return true
end

M.git_compare_what = {
  { text = 'Working copy', cmd = 'DiffviewOpen -uno' },
  {
    text = 'Branch ▶',
    handler = function()
      telescope.git_branches { attach_mappings = openDiffView }
    end,
  },
  {
    text = 'Commit ▶',
    handler = function()
      telescope.git_commits { attach_mappings = openDiffView }
    end,
  },
  {
    text = 'Branch "merge base" (PR like) ▶',
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
    text = ' Amend',
    cmd = 'silent !git commit --amend --no-edit',
  },
  -- {
  --   text = ' Cached',
  --   command = 'git diff --cached',
  -- },
  {
    text = ' file history',
    handler = telescope.git_bcommits,
  },
  {
    text = ' line history',
    handler = package.loaded.snacks.picker.git_log_line,
  },
  {
    text = ' Reset file',
    cmd = '!git reset HEAD "%"',
  },
  {
    text = ' Checkout branch',
    handler = telescope.git_branches,
  },
  {
    text = ' Stash changes ▶',
    options = {
      {
        text = ' Push',
        handler = function()
          vim.ui.input({
            prompt = 'Stash message: ',
          }, function(input)
            vim.cmd('!git stash push -m "' .. input .. '"')
          end)
        end,
      },
      { text = '󰋺 Apply', handler = telescope.git_stash },
    },
  },
} -- }}}

M.main_menu = {
  {
    text = ' Git ▶',
    options = M.git_menu,
  },
  {
    text = ' DiffView ▶',
    options = M.git_compare_what,
  },
  { text = ' Runnables ▶', cmd = 'OverseerRun' },
  { text = ' Silicon', cmd = "'<,'> Silicon" },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy' },
  { text = ' Scp cra', cmd = '!scp "%" cra:/tmp' },
}

return M
