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
require("lazy").setup({
  { "akinsho/toggleterm.nvim", config = require("plugins.toggleterm") },
  { "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = require("plugins.bufferline") },
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" }, config = require("plugins.neo-tree") },
  { "lewis6991/gitsigns.nvim", config = require("plugins.gitsigns") },
  { "rafi/awesome-vim-colorschemes" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "MunifTanjim/nui.nvim" },
  { "neoclide/coc.nvim", branch = "release", config = require("plugins.coc") },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = require("plugins.treesitter") },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = require("plugins.telescope") },
  { "ahmedkhalf/project.nvim", config = require("plugins.project") },
  { "goolord/alpha-nvim"},
})

-- Include settings and keymaps
require("settings")
require("keymaps")
require("plugins/statusline")
require("plugins/alpha")

