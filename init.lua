vim.loader.enable()

require('config.options').setup()
pcall(require, 'config.custom')

-- PackChanged hooks (must be BEFORE any vim.pack.add() call)
local augroup = vim.api.nvim_create_augroup('pack-hooks', { clear = true })
vim.api.nvim_create_autocmd('PackChanged', {
  group = augroup,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    -- Rebuild treesitter parsers on install/update
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
    -- Rebuild telescope-fzf-native on install/update
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'
      vim.fn.system({ 'make', '-C', path })
    end
    -- Rebuild LuaSnip jsregexp on install/update
    if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
      if vim.fn.executable('make') == 1 then
        local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/LuaSnip'
        vim.fn.system({ 'make', 'install_jsregexp', '-C', path })
      end
    end
  end,
})

-- Everything else is handled by plugin/ directory (auto-sourced alphabetically)
-- vim: ts=2 sts=2 sw=2 et
