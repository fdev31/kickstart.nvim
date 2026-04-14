-- vim:ts=2:sw=2:et:
local settings = require 'config.settings'

local telescope = require 'telescope.builtin'
local gitpick = require 'config.lib.gitpickers'
local partial = require('config.lib.core').partial
local git = require 'config.lib.git'

local M = {}
-- Menu structure
M.git_compare_what = {
  { text = 'Working copy', cmd = settings.diff_command },
  {
    text = 'Branch ▶',
    handler = partial(telescope.git_branches, { attach_mappings = gitpick.openDiffView }),
  },
  {
    text = 'Commit ▶',
    handler = partial(telescope.git_commits, { attach_mappings = gitpick.openDiffView }),
  },
  {
    text = 'Branch "merge base" (PR like) ▶',
    handler = partial(telescope.git_branches, { attach_mappings = gitpick.openDiffViewMB }),
  },
}

M.git_menu = { --{{{
  {
    text = ' Commit',
    handler = function()
      git.close_diff_view()
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
    text = ' Push',
    handler = function()
      git.close_diff_view()
      vim.cmd 'G push'
    end,
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
    text = '  File History',
    handler = telescope.git_bcommits,
  },
  {
    text = '⎼⎼ Line History',
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
    handler = partial(telescope.git_branches, { attach_mappings = gitpick.cherryPickCommitsFromBranch }),
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
} -- }}}

M.update_menu = {
  { text = '󰚰 Plugins (vim.pack)', handler = function() vim.pack.update() end },
  { text = ' Force update (no confirm)', handler = function() vim.pack.update(nil, { force = true }) end },
  { text = '󰁨 Revert to lockfile', handler = function() vim.pack.update(nil, { target = 'lockfile' }) end },
  { text = '󰓙 Plugin health', cmd = 'checkhealth vim.pack' },
  { text = ' 3rd party (Mason)', cmd = 'Mason' },
}

M.main_menu = {
  { text = ' DiffView ▶', options = M.git_compare_what },
  { text = ' Runnables ▶', cmd = 'OverseerRun' },
  { text = ' Git ▶', options = M.git_menu },
  { text = ' Copy diff', cmd = '!git diff "%" | wl-copy' },
  { text = ' Scp cra', cmd = '!scp "%" cra:/tmp' },
  { text = '󰚰 Update ▶', options = M.update_menu },
  { text = ' Venv selector', cmd = 'VenvSelect' },
  { text = ' PIO menu', cmd = 'Piomenu' },
  -- { text = '󰽿 Treesitter context (toggle)', handler = require('treesitter-context').toggle },
}

return M
