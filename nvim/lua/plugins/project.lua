return function()
	require("project_nvim").setup({
	  manual_mode = false, -- Automatically detect project roots using `.git` or similar
	  detection_methods = { "pattern" },
	  patterns = { ".git", "Makefile", "package.json" }, -- Root patterns
	})
end
