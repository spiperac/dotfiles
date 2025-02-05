local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- General Key Mappings

-- Map Leader + o to move to the next split
map('n', '<Leader>o', '<C-w>w', opts)
-- Close buffer 
map('n', '<Leader>q', '<C-w>c', opts)

map("n", "<C-n>", ":Neotree toggle<CR>", opts)
-- remove search highlight
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
vim.keymap.set("n", "gf", vim.lsp.buf.format, {})

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- Lazy git
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>", opts)

-- Telescope Key Mappings
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>s", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>h", "<cmd>Telescope help_tags<cr>", opts)

