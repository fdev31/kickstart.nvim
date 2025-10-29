local settings = require 'config.settings'
require('config.options').setup()
pcall(require, 'config.custom') -- let a chance to load custom code
local plugins_spec = require 'config.plugins'
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

local lazy_options = {
  ui = vim.tbl_deep_extend('force', {
    icons = settings.lazy_icons,
  }, settings.popup_style),
}

--Setup the plugins (lua/config/plugins/init.lua)
require('lazy').setup(plugins_spec, lazy_options)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
