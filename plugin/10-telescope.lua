-- vim:ts=2:sw=2:et:
-- DEFERRED: core fuzzy finder, many plugins depend on it
require('lazyload').on_vim_enter(function()
  -- Build hook: compile fzf native extension on install/update
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      if ev.data.spec.name == 'telescope-fzf-native.nvim' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
        if vim.fn.executable('make') == 1 then
          vim.fn.system({ 'make', '-C', ev.data.path })
        end
      end
    end,
  })

  vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
  })

  require('telescope').setup({
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      aerial = {
        highlight_on_hover = true,
        highlight_on_closest = true,
        autojump = true,
        show_guides = true,
        show_nesting = {
          ['_'] = true,
          python = true,
          js = true,
        },
      },
    },
  })

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
end)
