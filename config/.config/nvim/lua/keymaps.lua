---------------------------
--- Keymaps Configuration
---------------------------

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- General Key Mappings
-- map("n", "<leader>e", ':Lex!<CR>', vim.tbl_extend("force", opts, {desc = "File Explorer"}))
vim.cmd("command! W w")
vim.cmd("command! Q q")

-- Windows, Splitting and Resizing
map('n', '<A-h>', ":vertical resize +2<CR>", opts)
map('n', '<A-l>', ":vertical resize -2<CR>", opts)
map('n', '<C-d>', "<C-d>zz", opts)
map('n', '<C-u>', "<C-u>zz", opts)
map('n', '<Leader>o', '<C-w>w', vim.tbl_extend("force", opts, { desc = "Switch Window" }))
map('n', '<leader>v', ':vsplit<CR>', vim.tbl_extend("force", opts, { desc = "Vertical Split" }))
map('n', '<leader>h', ':split<CR>', vim.tbl_extend("force", opts, { desc = "Horizontal Split" }))
map('n', '<C-w><C-x>', ':qa!<CR>', vim.tbl_extend("force", opts, { desc = "Close all force!" }))
map('n', '<Leader>q', '<C-w>c', vim.tbl_extend("force", opts, { desc = "Close Window" }))

-- Movement
for _, mode in ipairs({ "n", "v", "i", "s" }) do
  vim.keymap.set(mode, "<C-j>", "<C-n>", opts)
  vim.keymap.set(mode, "<C-k>", "<C-p>", opts)
end

-- Completion keymaps
vim.keymap.set("i", "<C-Space>", "<C-x><C-o><C-p>", { desc = "Omni completion" })
vim.keymap.set("i", "<C-n>", "<C-x><C-n>", { desc = "Keyword completion" })
vim.keymap.set("i", "<C-f>", "<C-x><C-f>", { desc = "File path completion" })
vim.keymap.set("i", "<C-l>", "<C-x><C-l>", { desc = "Line completion" })

-- Utility
vim.keymap.set("n", "<leader>cp", ":%s/\\r//g<CR>", { desc = "Clean ^M characters" })                        -- remove windows copy/paste crlf
map("n", "<leader>u", ":nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear Search Highligts" })) -- remove search highlight
