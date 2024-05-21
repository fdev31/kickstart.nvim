vim.cmd 'highlight Normal guibg=NONE ctermbg=NONE'
vim.api.nvim_create_user_command('Chdir', 'cd %:h', {})

-- neovide / background-color {{{
if vim.g.neovide then
  mapKey('!', '<S-Insert>', '<C-R>+') -- allow Shit+Insert on the prompt

  vim.g.neovide_transparency = 0.7
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  vim.g.neovide_scale_factor = 0.8
  -- Dynamic Scale
  local _scaleChange = function(fac)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * fac
  end
  mapKey('n', '<C-=>', '', {
    silent = true,
    callback = function()
      _scaleChange(1.2)
    end,
  })
  mapKey('n', '<C-->', '', {
    silent = true,
    callback = function()
      _scaleChange(1 / 1.2)
    end,
  })
end

vim.api.nvim_set_hl(0, 'Normal', { ctermbg = nil, bg = nil, guibg = nil })
vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = nil, bg = nil, guibg = nil })
vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'NVimDarkGrey2' })
-- }}}
