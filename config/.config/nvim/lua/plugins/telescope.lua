return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				previewer = false,
				pickers = {
					find_files = {
            hidden=true,
						layout_config = {
							height = 0.70,
						},
					},
				},
        defaults = {
          file_ignore_patterns = {"*.git", ".git/*", "node_modules/*", "target/*"},
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
