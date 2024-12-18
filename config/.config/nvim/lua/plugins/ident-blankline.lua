return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      exclude = {
        filetypes = { "help", "lazy", "dashboard", "terminal" },
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
}
