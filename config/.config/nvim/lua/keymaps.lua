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

-- Plugin Key Mappings
map("n", "<C-l>", ':BuffHunter<CR>', opts)

-- Use Tab to navigate through the completion menu
vim.api.nvim_set_keymap("i", "<Tab>", 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { noremap = true, expr = true })

-- Use Enter to confirm the selected completion item
vim.api.nvim_set_keymap("i", "<CR>", 'pumvisible() ? coc#pum#confirm() : "\\<CR>"', { noremap = true, expr = true, silent = true })

-- Show documentation in a preview window
vim.api.nvim_set_keymap("n", "K", ":lua show_documentation()<CR>", opts)

-- Function for showing documentation
function show_documentation()
  if vim.bo.filetype == "vim" or vim.bo.filetype == "help" then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  else
    vim.fn.CocAction("doHover")
  end
end

-- Telescope Key Mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

