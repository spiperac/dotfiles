local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- General Key Mappings
map("n", "<C-n>", ":Neotree toggle<CR>", opts)
map("n", "<leader>e", ":NeoTreeFocusToggle<CR>", opts)
map("n", "<leader>t", ":ToggleTerm<CR>", opts)
map("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<ESC>u", ":nohlsearch<CR>", opts)

-- Plugin Key Mappings
map("n", "<C-l>", ':BuffHunter<CR>', opts)

-- Show documentation in a preview window
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "rn", vim.lsp.buf.rename, {})

vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, {})
-- Lazy git
-- vim.keymap.set("n", "<ladder>lg", ":LazyGit<CR>", opts)

-- Telescope Key Mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

