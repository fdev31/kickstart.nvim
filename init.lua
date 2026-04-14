vim.loader.enable()

require('config.options').setup()
pcall(require, 'config.custom')

-- Auto-accept plugin installations (skip confirmation prompt)
do
  local orig_add = vim.pack.add
  vim.pack.add = function(specs, opts)
    opts = vim.tbl_extend('keep', opts or {}, { confirm = false })
    return orig_add(specs, opts)
  end
end

local special_handlers = {
  ['nvim-treesitter'] = function()
    vim.cmd 'TSUpdate'
  end,
  ['telescope-fzf-native.nvim'] = function()
    if vim.fn.executable 'make' == 1 then
      local path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/telescope-fzf-native.nvim'
      vim.fn.system { 'make', '-C', path }
    end
  end,
  ['LuaSnip'] = function()
    if vim.fn.executable 'make' == 1 then
      local path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/LuaSnip'
      vim.fn.system { 'make', 'install_jsregexp', '-C', path }
    end
  end,
}

-- PackChanged hooks (must be BEFORE any vim.pack.add() call)
local augroup = vim.api.nvim_create_augroup('pack-hooks', { clear = true })
vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    -- Handle install & updates
    if not (kind == 'install' or kind == 'update') then
      return
    end
    if special_handlers[name] then
      special_handlers[name]()
    end
  end,
})

-- Everything else is handled by plugin/ directory (auto-sourced alphabetically)
-- vim: ts=2 sts=2 sw=2 et
