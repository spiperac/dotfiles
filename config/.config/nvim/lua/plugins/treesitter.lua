vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "master" },
})

require("nvim-treesitter").setup {
  --ensure_installed = { "python", "rust", "lua", "cpp", "terraform", "php" },
  -- auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  context = {
    enable = false,
  },
}

require 'treesitter-context'.setup {
  enable = false,
}
