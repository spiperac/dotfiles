return function()
	require("bufferline").setup({
	  options = {
	    separator_style = "slant",
	    show_buffer_close_icons = true,
	    show_close_icon = false,
	    offsets = {
	      {
		filetype = "neo-tree",
		text = "File Explorer",
		text_align = "left",
		separator = true,
	      },
	    },
	  },
	})
end
