return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      -- Define sources for Python and Rust
      null_ls.setup({
        sources = {
          -- Formatting
          null_ls.builtins.formatting.stylua, -- Lua formatter
          null_ls.builtins.formatting.golines, -- Go formatter
          null_ls.builtins.formatting.black, -- Python formatter
          null_ls.builtins.formatting.isort, -- Python import sorter

          -- Diagnostics
          null_ls.builtins.diagnostics.mypy, -- Python type checker

          -- Code Actions
          null_ls.builtins.code_actions.gitsigns, -- Git actions
          null_ls.builtins.code_actions.refactoring, -- Refactoring actions
        },
      })
    end,
  },
}
