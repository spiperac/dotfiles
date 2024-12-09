-- Load Lazy.nvim and plugins
require("lazy").setup({
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
    config = require("plugins.buffhunter") 
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
  }


  -- Themes 00
  { "marko-cerovac/material.nvim" },


})
