-- Load Lazy.nvim and plugins
require("lazy").setup({
  dev = {
    -- Directory where you store your local plugin projects. If a function is used,
    -- the plugin directory (e.g. `~/projects/plugin-name`) must be returned.
    ---@type string | fun(plugin: LazyPlugin): string
    path = "~/projects/",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  { 
    "nvim-neo-tree/neo-tree.nvim", 
    dependencies = { 
      "nvim-lua/plenary.nvim", 
      "MunifTanjim/nui.nvim" 
    }, 
    config = require("plugins.neo-tree") 
  },

  { 
    "lewis6991/gitsigns.nvim", 
    config = require("plugins.gitsigns") 
  },
  
  { 
    "neoclide/coc.nvim", 
    branch = "release", 
    config = require("plugins.coc") 
  },
  
  { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate", 
    config = require("plugins.treesitter") 
  },
  
  { 
    "nvim-telescope/telescope.nvim", 
    dependencies = { 
      "nvim-lua/plenary.nvim" 
    }, 
    config = require("plugins.telescope") 
  },

  { "goolord/alpha-nvim" },
  { "nvim-tree/nvim-web-devicons" },

  { 
    "spiperac/buffhunter.nvim", 
    config = require("plugins.buffhunter"),
    dev = true,
    dir = "~/projects/buffhunter.nvim"

 },

  { 
    "kdheepak/lazygit.nvim", 
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }

  },

  -- Noice & Leet
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require("plugins.noice"),
    dependencies = {
      "MunifTanjim/nui.nvim",
      }
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },  
  },


  -- Themes
  { "marko-cerovac/material.nvim" },
  { "loctvl842/monokai-pro.nvim" }
})
