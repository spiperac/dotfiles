return {
  -- Themes
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        background_clear = {
          "telescope",
        },
        ident_blankline = {
          context_highlight = "pro",
        },
        devicons = true,
      })

      -- Colorscheme
      vim.cmd("colorscheme monokai-pro")
    end,
  },
}
