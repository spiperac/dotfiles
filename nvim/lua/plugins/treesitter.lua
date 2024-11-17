return function()
	require'nvim-treesitter.configs'.setup {
	  ensure_installed = {"python",
			      "rust",
			      "c",
                              "lua", 
			      "javascript", 
                              "html", 
			      "css",
			      "terraform",
			      "markdown",
			      "bash",
			      "cmake",
			      "make",
			      "arduino",
			      "yaml",
			      "toml",
			      "php",
			      "nginx" }, -- Add your desired languages
	  highlight = {
	    enable = true, -- Enable Treesitter-based syntax highlighting
	  },
	  indent = {
	    enable = true, -- Optional: Enable indentation based on Treesitter
	  },
	}
end
