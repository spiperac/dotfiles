return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        previewer = false,
        pickers = {
          find_files = {
            hidden = true,
            layout_config = {
              height = 0.70,
            },
          },
        },
        defaults = {
          file_ignore_patterns = { "*.git", ".git/*", "node_modules/*", "target/*" },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<Esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          }
        },
        extensions = {
          projects = {
            detection_methods = { "pattern" },
            patterns = { ".git", "Makefile", "package.json" },
          },
        },
      })
    end,
  },
}
