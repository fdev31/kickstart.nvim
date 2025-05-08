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
  -- {
  --   text = ' Cached',
  --   command = 'git diff --cached',
  -- },
  {
    text = ' File history',
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
  { text = '󰚰 Lazy update', cmd = 'Lazy update' },
  { text = '󱊒 Mason update', cmd = 'MasonToolsUpdate' },
  { text = '󰽿 Treesitter context (toggle)', handler = require('treesitter-context').toggle },
}

return M
