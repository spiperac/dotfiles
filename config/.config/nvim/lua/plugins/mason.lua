vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup({
  PATH = "prepend",
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "terraform-ls",
    "pyright",
    "black",
  },
  run_on_start = true,
})
