return {
  { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate", 
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {"python",
                "rust",
                "c",
                "lua", 
                "javascript", 
                "html", 
                "css",
                "terraform",
                "bash",
                "markdown",
                "markdown_inline",
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
  },
}

