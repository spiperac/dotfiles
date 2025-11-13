-----------------------
-- LSP Configuration
----------------------

-- Define LSP Servers
local servers = {
  pyright = {
    formatter = "black",
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
  },
  intelephense = {
    formatter = "phpcbf",
    cmd = { "phpactor", "language-server" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_markers = { "go.mod", ".git" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          nilness = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  },
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "compile_commands.json", "CMakeLists.txt", ".git" },
  },
  terraformls = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "hcl" },
    root_markers = { ".terraform", ".git" },
  },
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

-- Diagnostics
vim.diagnostic.config({
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Auto Complete
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    end

    -- Formatting keymap
    if client:supports_method('textDocument/formatting') then
      vim.keymap.set("n", "gf", vim.lsp.buf.format, opts)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf })
        end,
      })
    end

    -- Signature help
    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show diagnostic" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function()
    vim.cmd.redrawstatus()
  end,
})

-- Auto completion options
vim.opt.completeopt = { 'fuzzy', 'menuone', 'noselect', 'popup' }

-- Suppress specific LSP error messages
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("completionItem/resolve.*not supported") then
    -- Silently ignore this specific error
    return
  end
  notify(msg, level, opts)
end
