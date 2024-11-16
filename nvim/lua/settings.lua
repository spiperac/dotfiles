-- Neo-tree Configuration
require('gitsigns').setup()

require("neo-tree").setup({
  popup_border_style = "rounded",  -- if available, try different styles like "single", "double", etc.
  window = {
    position = "left",       -- Neo-tree on the left side
    width = 30,              -- Set your preferred width
    mappings = {
      ["q"] = "close_window", -- Key mapping to close Neo-tree
    },
  },
  filesystem = {
    follow_current_file = true,  -- Option to follow the current file in Neo-tree
    hijack_netrw_behavior = "open_current", -- Ensures Neo-tree replaces netrw
  },
  close_if_last_window = false,  -- Closes Neo-tree if it's the last open window
})

-- ToggleTerm Configuration
require("toggleterm").setup({
    size = 10,
    open_mapping = [[<C-\>]],
    direction = "horizontal",
})

require("bufferline").setup {
  options = {
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      }
    },
    separator_style = "slant",
    show_buffer_close_icons = true,
    show_close_icon = false,
  }
}

-- Startup Functions



