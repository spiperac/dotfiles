return {
  {
    "SmiteshP/nvim-navic",
  },
  {
    "LunarVim/breadcrumbs.nvim",
    config = function()
      require("nvim-navic").setup {
        lsp = {
          auto_attach = true,
        },
      }

      require("breadcrumbs").setup()
    end
  }
}
