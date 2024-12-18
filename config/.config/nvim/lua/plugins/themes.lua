return {
  -- Themes
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup()

      -- Colorscheme
      vim.cmd("colorscheme monokai-pro")
    end,
  },
}
