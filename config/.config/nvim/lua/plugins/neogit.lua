-- Install NeoGit
vim.pack.add({ 
 { src = "https://github.com/nvim-lua/plenary.nvim" },
 { src = "https://github.com/sindrets/diffview.nvim" },
 { src = "https://github.com/neogitorg/neogit" },
})

require('neogit').setup({
  integrations = {
    diffview = true
  }
})

-- Magit-like keymaps
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit status' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<CR>', { desc = 'Neogit commit' })
vim.keymap.set('n', '<leader>gl', '<cmd>Neogit log<CR>', { desc = 'Neogit log' })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Neogit log' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<CR>', { desc = 'Neogit log' })
