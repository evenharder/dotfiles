-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.shell = "/usr/bin/zsh"
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  -- Disable paste via OSC 52 to avoid timeout errors, rely on WezTerm's native paste
  paste = {
    ["+"] = function() end,
    ["*"] = function() end,
  },
}
vim.g.snacks_animate = false -- not my style and quite buggy on clipboard paste

vim.o.winborder = "single"
