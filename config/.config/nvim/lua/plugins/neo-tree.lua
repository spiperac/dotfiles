return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim", 
      "MunifTanjim/nui.nvim" 
    }, 

    config = function() 
       require("neo-tree").setup({
        sources = {
          "filesystem",  -- File system view
          "buffers",     -- Buffers view
        },
        popup_border_style = "rounded",
          enable_git_Status = true,
          padding = 1,
        window = {
          position = "right",
          width = 40,
          mappings = {
            ["q"] = "close_window",
          },
        },
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
            },
            hide_dotfiles = false,
          follow_current_file = {
            enabled = true,
          },
          hijack_netrw_behavior = "open_current",
            -- Custom component to show only project/dir name instead of full path 
            components = {
                name = function(config, node, state)
                    local components = require('neo-tree.sources.common.components')
                    local name = components.name(config, node, state)
                    if node:get_depth() == 1 then
                        name.text = vim.fs.basename(vim.loop.cwd() or '')
                    end
                    return name
                end,
            },
        },
        close_if_last_window = false,
          name = {
            trailing_slash = false,
          },

      })
    end
  
  }

}

