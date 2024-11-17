return function()
	require("neo-tree").setup({
	  popup_border_style = "rounded",
	  window = {
	    position = "left",
	    width = 30,
	    mappings = {
	      ["q"] = "close_window",
	    },
	  },
	  filesystem = {
	    follow_current_file = {
	      enabled = true,
	    },
	    hijack_netrw_behavior = "open_current",
	  },
	  close_if_last_window = false,
	})
end
