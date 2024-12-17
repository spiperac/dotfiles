return {
  { 
    'williamboman/mason.nvim',
    config = function() 
      require("mason").setup()
    end
  
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls",
                            "rust_analyzer", 
                            "gopls",
                            "pyright"
                           }
      })
    end
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.pyright.setup({})
      lspconfig.gopls.setup({})
    end
  }
}

