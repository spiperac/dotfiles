return function()
	require'nvim-treesitter.configs'.setup {
	  ensure_installed = {"python",
			      "rust", 
                              "lua", 
			      "javascript", 
                              "html", 
			      "css",
			      "terraform",
			      "markdown",
			      "bash",
			      "arduino",
			      "yaml",
			      "toml" }, -- Add your desired languages
	  highlight = {
	    enable = true, -- Enable Treesitter-based syntax highlighting
	  },
	  indent = {
	    enable = true, -- Optional: Enable indentation based on Treesitter
	  },
	}
end
