local M = {}

local telescope = require 'telescope.builtin'

local cherryPickCommitsFromBranch = function(_, action)
  action('i', '<CR>', function(prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    -- start a telescope listing commits of this branch
    telescope.git_commits {
      branch = selection.value,
      attach_mappings = function(_, action)
        action('i', '<CR>', function(prompt_bufnr)
          local commit = require('telescope.actions.state').get_selected_entry()
          require('telescope.actions').close(prompt_bufnr)
          vim.cmd('Git cherry-pick ' .. commit.value .. ' -x')
        end)
        return true
      end,
    }
  end)
  return true
end

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
    text = ' Commit',
    handler = function()
      require('diffview').close()
      vim.cmd 'Neotree close'
      vim.cmd 'G commit'
    end,
  },
  {
    text = ' Amend',
    cmd = '!git commit --amend --no-edit',
    silent = true,
  },
  {
    text = '󰇚 Pull',
    cmd = 'G pull',
  },
  {
    text = ' View Cached',
    cmd = 'G diff --cached',
  },
  {
    text = '  File history',
    handler = telescope.git_bcommits,
  },
  {
    text = ' Line history',
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
  { -- TODO: allow cherry-picking multiple commits
    -- alternative: ask to cherry-pick every commit AFTER the selected one
    text = ' Cherry-Pick ▶',
    handler = function()
      telescope.git_branches { attach_mappings = cherryPickCommitsFromBranch }
    end,
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
            if input then
              vim.cmd('!git stash push -m "' .. input .. '"')
            else
              vim.notify('Canceled', 'info', { title = 'Stash' })
            end
          end)
        end,
      },
      { text = '󰋺 Apply', handler = telescope.git_stash },
    },
  },
  {
    text = ' Push',
    handler = function()
      require('diffview').close()
      vim.cmd 'G push'
    end,
  },
} -- }}}

M.main_menu = {
  { text = ' DiffView ▶', options = M.git_compare_what },
  { text = ' Runnables ▶', cmd = 'OverseerRun' },
  { text = ' Git ▶', options = M.git_menu },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy' },
  { text = ' Scp cra', cmd = '!scp "%" cra:/tmp' },
  { text = '󰚰 Lazy update', cmd = 'Lazy update' },
  { text = '󱊒 Mason update', cmd = 'MasonToolsUpdate' },
  { text = ' Venv selector', cmd = 'VenvSelect' },
  { text = ' PIO menu', cmd = 'Piomenu' },
  -- { text = '󰽿 Treesitter context (toggle)', handler = require('treesitter-context').toggle },
}

return M
