return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        sh = { "shellcheck", "shfmt" },
        javascript = { "prettierd" },
        cpp = { "clang_format" },
        json = { "prettierd" },
        rust = { "rust_fix", "ast_grep" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {},
    },
  },
}
