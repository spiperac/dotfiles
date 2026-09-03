vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "master" },
})

require("nvim-treesitter").setup {
  ensure_installed = { "python", "rust", "lua", "cpp", "terraform", "php", "bash", "yaml", "go" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
}
