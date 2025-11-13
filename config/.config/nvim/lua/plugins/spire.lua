--
-- Spire Plugin Config
--
vim.pack.add({
 { src = "https://github.com/spiperac/spire.nvim" },
})

require("spire").setup({
  prompt_location = "bottom",
  icons = {
    provider = 'mini'
  },
  files = {
    mappings = {
      open_vsplit = '<C-s>'
    }
  },
  grep = {
    hidden_files = true,
  }
})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Plugin Key Mappings
map("n", "<leader>sf", ':SpireFiles<CR>', vim.tbl_extend("force", opts, { desc = "Spire Files" }))
map("n", "<leader>sb", ':SpireBuffers<CR>', vim.tbl_extend("force", opts, { desc = "Spire Buffers" }))
map("n", "<leader>sg", ':SpireGrep<CR>', vim.tbl_extend("force", opts, { desc = "Spire Grep Search" }))
map("n", "<leader>sp", ':SpireProjects<CR>', vim.tbl_extend("force", opts, { desc = "Spire Projects Directory" }))
