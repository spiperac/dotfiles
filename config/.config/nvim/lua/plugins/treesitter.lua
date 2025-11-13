require("nvim-treesitter.configs").setup {
  --ensure_installed = { "python", "rust", "lua", "cpp", "terraform", "php" },
  -- auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
}
