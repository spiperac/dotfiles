return function()
	require("bufferline").setup({
    highlights = {
        offset_separator = {
            fg = "#ebdbb2",
            bg = "#1d2021",
        },
    },
    options = {
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        offsets = {
                      {
                        filetype = "neo-tree",
                        text = "",
                        text_align = "left",
                        separator = true,
                      },
                },
    },

	})
end
