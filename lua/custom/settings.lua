vim.cmd 'highlight Normal guibg=NONE ctermbg=NONE'
vim.api.nvim_create_user_command('Chdir', 'cd %:h', {})
