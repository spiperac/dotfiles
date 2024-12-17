-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Load Lazy.nvim and plugins
require("lazy").setup("plugins")

-- Include settings and keymaps
require("settings")
require("keymaps")

-- Include custom plugins
require("custom/statusline")
require("custom/alpha")

