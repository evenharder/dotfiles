return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup({
      pip = {
        install_args = {
          "--trusted-host",
          "pypi.org",
          "--trusted-host",
          "pypi.python.org",
          "--trusted-host",
          "files.pythonhosted.org",
        },
      },
    })
    vim.lsp.enable("pylsp")
    vim.lsp.enable("bashls")

    vim.lsp.config("pylsp", {
      plugins = {
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        yapf = { enabled = false },
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
        ruff = { enabled = true },
      },
    })
  end,
}
