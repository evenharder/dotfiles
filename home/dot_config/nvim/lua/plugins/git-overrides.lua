local function diff_base()
  local candidates = {
    { ref = "upstream/master", lookup = "refs/remotes/upstream/master" },
    { ref = "upstream/main", lookup = "refs/remotes/upstream/main" },
    { ref = "master", lookup = "refs/heads/master" },
    { ref = "main", lookup = "refs/heads/main" },
  }
  for _, c in ipairs(candidates) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", c.lookup })
    if vim.v.shell_error == 0 then
      vim.notify("diff base: " .. c.ref, vim.log.levels.INFO, { title = "git-overrides" })
      return c.ref
    end
  end
  vim.notify("diff base: HEAD (no master/main found)", vim.log.levels.WARN, { title = "git-overrides" })
  return "HEAD"
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gD",
        function()
          Snacks.picker.git_diff({ base = diff_base(), group = true })
        end,
        desc = "Git Diff (auto-detected main)",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gho",
        function()
          require("gitsigns").diffthis(diff_base())
        end,
        desc = "Diff This (auto-detected main)",
      },
    },
  },
}
