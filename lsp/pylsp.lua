return {
  settings = {
    pylsp = {
      signature = {
        formatter = 'ruff',
      },
      plugins = {
        autopep8 = { enabled = false },
        yapf = { enabled = true },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = true },
        pydocstyle = { enabled = false },
        pylsp_mypy = { enabled = true },
        jedi_completion = { fuzzy = true },
        jedi_symbols = { enabled = true },
      },
    },
  },
}
