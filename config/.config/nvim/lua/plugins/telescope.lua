return {
  { 
    "nvim-telescope/telescope.nvim", 
    dependencies = { 
      "nvim-lua/plenary.nvim" 
    }, 
    config = function()
    require("telescope").setup({
        previewer = false,
        extensions = {
          projects = {
            detection_methods = { "pattern" },
            patterns = { ".git", "Makefile", "package.json" },
          },
        },
      })
    end 
  },

}
