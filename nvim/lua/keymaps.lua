local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- General Key Mappings
map("n", "<C-n>", ":Neotree toggle<CR>", opts)
map("n", "<leader>e", ":NeoTreeFocusToggle<CR>", opts)
map("n", "<leader>t", ":ToggleTerm<CR>", opts)
map("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<ESC>u", ":nohlsearch<CR>", opts)

-- Coc.nvim Key Mappings
map("n", "gd", "<Plug>(coc-definition)", opts)
map("n", "gy", "<Plug>(coc-type-definition)", opts)
map("n", "gi", "<Plug>(coc-implementation)", opts)
map("n", "gr", "<Plug>(coc-references)", opts)
map("n", "K", ":call CocAction('doHover')<CR>", opts)

-- Telescope Key Mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

