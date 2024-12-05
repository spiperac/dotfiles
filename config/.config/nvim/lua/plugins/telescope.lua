return function()
	require("telescope").setup({
	  extensions = {
	    projects = {
	      detection_methods = { "pattern" },
	      patterns = { ".git", "Makefile", "package.json" },
	    },
	  },
	})
end
