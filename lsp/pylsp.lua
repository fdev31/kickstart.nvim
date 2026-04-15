return {
  settings = {
    pylsp = {
      signature = {
        formatter = 'ruff',
      },
      plugins = {
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pylsp_mypy = { enabled = true },
        jedi_completion = { fuzzy = true },
        jedi_symbols = { enabled = true },
      },
    },
  },
}
