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
    vim.lsp.enable("ty")
    vim.lsp.enable("bashls")
  end,
}
