-- Set Leader key to Space key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Include settings and keymaps
require("theme")
require("settings")
require("keymaps")
require("lsp")
require("status")

-- Plugins
require("plugins.mini")
require("plugins.treesitter")
require("plugins.neogit")
require("plugins.debuggers")
require("plugins.blog")
require("plugins.spire")
