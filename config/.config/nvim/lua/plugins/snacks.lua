return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" }, -- Header section
          {
            pane = 2, -- Pane number (2nd pane)
            section = "terminal", -- Terminal section
            cmd = "uname -a", -- Command to run in the terminal
            height = 5, -- Height of the terminal pane
            padding = 1, -- Padding around the pane
          },
          { section = "keys",  gap = 1, padding = 1 }, -- Shortcut keys section
          {
            pane = 2, -- Pane number (2nd pane)
            icon = " ", -- Icon for the section
            title = "Recent Files", -- Title of the section
            section = "recent_files", -- Recent files section
            indent = 2, -- Indentation
            padding = 1, -- Padding
          },
          {
            pane = 2, -- Pane number (2nd pane)
            icon = " ", -- Icon for the section
            title = "Projects", -- Title of the section
            section = "projects", -- Projects section
            indent = 2, -- Indentation
            padding = 1, -- Padding
          },
          {
            pane = 2, -- Pane number (2nd pane)
            icon = " ", -- Icon for the section
            title = "Git Status", -- Title of the section
            section = "terminal", -- Terminal section
            enabled = function()
              return Snacks.git.get_root() ~= nil -- Only show if in a Git repo
            end,
            cmd = "git status --short --branch --renames", -- Git command
            height = 5, -- Height of the terminal pane
            padding = 1, -- Padding
            ttl = 5 * 60, -- Time-to-live (5 minutes)
            indent = 3, -- Indentation
          },
          { section = "startup" }, -- Startup section
        },
      },
      explorer = {
        enabled = true,
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            layout = { layout = { position = "right" } },
          },
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader>f",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>s",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
    },
  },
}
