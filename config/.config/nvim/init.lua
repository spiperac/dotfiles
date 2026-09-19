-- init.lua --- Neovim configuration -*- lua -*-

-- ============================================================
-- LEADER
-- ============================================================

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================
-- SETTINGS
-- ============================================================

-- General
vim.opt.relativenumber = true
vim.opt.number = true      -- Enable line numbers
vim.opt.mouse = 'a'        -- Mouse support
vim.o.termguicolors = true -- Enable true color support

-- System clipboard, set after startup: probing the clipboard tool is slow
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Spaces instead of tab
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 2   -- Number of spaces for indentation
vim.o.tabstop = 2      -- Number of spaces for a tab
vim.o.softtabstop = 2

-- Indentation
vim.o.smartindent = true -- Smart auto-indenting
vim.o.breakindent = true

-- Splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- Cases, to help in searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Files
vim.o.undofile = true
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Visual
vim.o.winborder = 'rounded'
vim.o.pumborder = 'single'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.showmatch = true
vim.o.signcolumn = "no"
vim.opt.guicursor = "n-v-c:block-blinkwait500-blinkon500-blinkoff500"

-- Disable auto comment on new line (ftplugins re-enable it, so reapply per buffer)
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
})

-- ============================================================
-- THEME
-- ============================================================

vim.pack.add({
  { src = 'https://github.com/srcery-colors/srcery-vim' },
  { src = 'https://github.com/morhetz/gruvbox' },
  { src = 'https://github.com/afonsofrancof/OSC11.nvim' },
})

vim.cmd("colorscheme srcery")

-- Follow the terminal's light/dark theme (OSC 11). OSC11.nvim hooks
-- TermResponse directly, so srcery's `set background=dark` can't break it.
require("osc11").setup({
  on_dark = function()
    vim.opt.background = "dark"
    if vim.g.colors_name ~= "srcery" then
      vim.cmd("colorscheme srcery")
    end
  end,
  on_light = function()
    vim.opt.background = "light"
    if vim.g.colors_name ~= "gruvbox" then
      vim.cmd("colorscheme gruvbox")
    end
  end,
})

-- Nvim queries the terminal's background before user config loads, so OSC11's
-- listener misses the first response. Re-query so a terminal already in light
-- mode is respected from the first frame.
if vim.o.ttyfast then
  vim.api.nvim_ui_send('\027]11;?\007')
end

do
  -- Re-applied on every colorscheme load so theme toggles (OSC 11) keep the
  -- transparent/padding look instead of inheriting colors from the new theme.
  local bg_groups = {
    -- Core editor
    "Normal", "NormalNC", "EndOfBuffer",
    "LineNr", "CursorLineNr", "SignColumn", "FoldColumn",

    -- Floating windows / popups
    "NormalFloat", "FloatBorder", "FloatTitle",
    "Pmenu", "WinBar", "WinBarNC", "MsgArea",

    -- Tabline (blank padding row)
    "TabLine", "TabLineFill", "TabLineSel",

    -- mini.nvim
    "MiniFilesNormal", "MiniFilesBorder", "MiniFilesTitle", "MiniFilesTitleFocused",
    "MiniPickNormal", "MiniPickBorder", "MiniPickPrompt",
  }

  local function apply_theme_patches()
    -- Keep transparency: strip backgrounds of UI chrome so the terminal shows through.
    -- (This block is your original config's bg-strip, unchanged.)
    for _, group in ipairs(bg_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      hl.bg, hl.ctermbg = nil, nil
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- Mode indicator colors (unchanged from the original config)
    vim.cmd([[
      hi StatusInsert guibg=green guifg=white
      hi StatusVisual guibg=orange guifg=#0f0f0f
      hi StatusReplace guibg=red guifg=white
      hi StatusCommand guibg=purple guifg=white
    ]])

    if vim.o.background == "light" then
      -- Gruvbox light's StatusLine/StatusLineNC use gui=inverse, which nvim
      -- forwards to the terminal as SGR 7 (inverse video). The terminal then
      -- swaps the colors of every group drawn inside the statusline (mode and
      -- branch text, etc.). Redeclare the bar without inverse, using the exact
      -- colors gruvbox's inverse would render on light anyway.
      vim.cmd([[
        hi StatusLine   guibg=#d5c4a1 guifg=#3c3836 gui=NONE
        hi StatusLineNC guibg=#ebdbb2 guifg=#7c6f64 gui=NONE

        " gruvbox's light Cursor is a bare inverse with no colors, which is
        " invisible on a transparent terminal. Give it a solid dark block.
        hi Cursor guibg=#3c3836 guifg=#fbf1c7
        hi! link vCursor Cursor
        hi! link iCursor Cursor
        hi! link lCursor Cursor

        " NORMAL-mode indicator + branch colors: dark text on the light bar
        hi GitStatus guifg=#3c3836
        hi GitClean guifg=#79740e
        hi GitDirty guifg=#9d0006
        hi GitAhead guifg=#af3a03
      ]])
    else
      -- srcery dark
      vim.cmd([[
        hi GitStatus guifg=white
        hi GitClean guifg=#7fa563
        hi GitDirty guifg=#d8647e
        hi GitAhead guifg=#f3be7c

        " srcery's CursorLine matches its background, so pickers need their own
        hi MiniPickMatchCurrent guibg=#3b3935
        hi MiniFilesCursorLine  guibg=#3b3935
      ]])
    end
  end

  apply_theme_patches()
  vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_theme_patches })
end

-- ============================================================
-- KEYMAPS
-- ============================================================

do
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  vim.cmd("command! W w")
  vim.cmd("command! Q q")

  -- Windows, Splitting and Resizing
  map('n', '<A-h>', ":vertical resize +2<CR>", opts)
  map('n', '<A-l>', ":vertical resize -2<CR>", opts)
  map('n', '<C-d>', "<C-d>zz", opts)
  map('n', '<C-u>', "<C-u>zz", opts)
  map('n', '<Leader>o', '<C-w>w', vim.tbl_extend("force", opts, { desc = "Switch Window" }))
  map('n', '<leader>v', ':vsplit<CR>', vim.tbl_extend("force", opts, { desc = "Vertical Split" }))
  map('n', '<leader>h', ':split<CR>', vim.tbl_extend("force", opts, { desc = "Horizontal Split" }))
  map('n', '<C-w><C-x>', ':qa!<CR>', vim.tbl_extend("force", opts, { desc = "Close all force!" }))
  map('n', '<Leader>q', '<C-w>c', vim.tbl_extend("force", opts, { desc = "Close Window" }))

  -- Movement
  for _, mode in ipairs({ "n", "v", "i", "s" }) do
    vim.keymap.set(mode, "<C-j>", "<C-n>", opts)
    vim.keymap.set(mode, "<C-k>", "<C-p>", opts)
  end

  -- Completion
  vim.keymap.set("i", "<C-Space>", "<C-x><C-o><C-p>", { desc = "Omni completion" })
  vim.keymap.set("i", "<C-n>", "<C-x><C-n>", { desc = "Keyword completion" })
  vim.keymap.set("i", "<C-f>", "<C-x><C-f>", { desc = "File path completion" })
  vim.keymap.set("i", "<C-l>", "<C-x><C-l>", { desc = "Line completion" })

  -- Utility
  vim.keymap.set("n", "<leader>cp", ":%s/\\r//g<CR>", { desc = "Clean ^M characters" })                        -- remove windows copy/paste crlf
  map("n", "<leader>u", ":nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear Search Highligts" })) -- remove search highlight
  map("n", "<leader>ps", '<cmd>lua vim.pack.update()<CR>', vim.tbl_extend("force", opts, { desc = "Update plugins" }))
end

-- ============================================================
-- LSP
-- ============================================================

do
  -- Servers
  local servers = {
    pyright = {
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
    phpactor = {
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
    yamlls = {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml" },
      root_markers = { ".git" },
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
    signs = false,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true }

      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      -- Auto Complete
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, {
          autotrigger = false,
        })
      end

      -- Formatting: one format-on-save hook per buffer, however many clients attach
      if client:supports_method('textDocument/formatting') then
        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LspFormat." .. ev.buf, { clear = true }),
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
end

-- ============================================================
-- STATUSLINE
-- ============================================================
-- Rendered on redraw from cached state. Git runs asynchronously.

do
  vim.o.laststatus = 3

  -- Mode label and highlight, by the first letter of the mode
  local modes = {
    n = { "NORMAL", "GitStatus" },
    i = { "INSERT", "StatusInsert" },
    v = { "VISUAL", "StatusVisual" },
    V = { "VISUAL", "StatusVisual" },
    ["\22"] = { "VISUAL", "StatusVisual" },
    R = { "REPLACE", "StatusReplace" },
    c = { "COMMAND", "StatusCommand" },
  }

  -- Git state per repository root: { branch, dirty, ahead, pending, stale }
  local git = {}

  local function git_root(buf)
    local root = vim.b[buf].status_git_root
    if root == nil then
      root = vim.fs.root(buf, ".git") or false
      vim.b[buf].status_git_root = root
    end
    return root or nil
  end

  local function refresh_git(root)
    local state = git[root]
    if not state then
      state = {}
      git[root] = state
    end
    if state.pending then
      state.stale = true
      return
    end
    state.pending = true

    vim.system(
      { "git", "--no-optional-locks", "status", "--porcelain=v2", "--branch" },
      { cwd = root, text = true },
      function(res)
        state.pending = false
        if res.code == 0 then
          local branch, ahead, dirty = nil, false, false
          for line in res.stdout:gmatch("[^\n]+") do
            local head = line:match("^# branch%.head (.+)")
            local ab = line:match("^# branch%.ab %+(%d+)")
            if head then
              branch = head
            elseif ab then
              ahead = tonumber(ab) > 0
            elseif line:sub(1, 1) ~= "#" then
              dirty = true
            end
          end
          state.branch, state.ahead, state.dirty = branch, ahead, dirty
        else
          state.branch = nil
        end

        vim.schedule(function()
          if state.stale then
            state.stale = false
            refresh_git(root)
          end
          vim.cmd.redrawstatus()
        end)
      end
    )
  end

  -- Escape statusline control characters in user text
  local function esc(text)
    return (text:gsub("%%", "%%%%"))
  end

  local function file_icon(ft)
    local ok, icons = pcall(require, "mini.icons")
    if ok and ft ~= "" then
      local found, icon = pcall(icons.get, "filetype", ft)
      if found and icon then
        return icon
      end
    end
    return "📄"
  end

  function _G.Statusline()
    local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)
    local bo = vim.bo[buf]

    -- Mode
    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    local m = modes[mode]
    local mode_part = m and ("%#" .. m[2] .. "# " .. m[1] .. " %*")
        or (" " .. mode:upper() .. " ")

    -- File
    local path = vim.api.nvim_buf_get_name(buf)
    local label = "[No Name]"
    if path ~= "" then
      label = vim.fn.fnamemodify(path, ":t") .. " · " .. vim.fn.fnamemodify(path, ":p:h:t")
    end
    local file_part = " " .. file_icon(bo.filetype) .. " " .. esc(label) .. " %p%% "
        .. (bo.modified and " [+]" or "")

    -- LSP
    local clients = vim.lsp.get_clients({ bufnr = buf })
    local lsp = clients[1] and clients[1].name or "none"

    -- Git
    local git_part = ""
    local root = git_root(buf)
    if root then
      local state = git[root]
      if not state then
        git[root] = {}
        vim.schedule(function() refresh_git(root) end)
      elseif state.branch then
        local hl = state.dirty and "GitDirty" or (state.ahead and "GitAhead" or "GitClean")
        git_part = "%#" .. hl .. "# " .. esc(state.branch) .. "%* "
      end
    end

    return mode_part
        .. file_part
        .. " %="
        .. "LSP:" .. esc(lsp) .. " "
        .. esc(bo.filetype) .. "/" .. esc(bo.fileencoding) .. "  "
        .. git_part .. "  "
  end

  vim.o.statusline = "%!v:lua.Statusline()"

  local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

  -- Refresh git state when it may have changed
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "ShellCmdPost", "TermLeave" }, {
    group = group,
    callback = function(args)
      local root = git_root(args.buf)
      if root then
        refresh_git(root)
      end
    end,
  })

  -- A renamed buffer may belong to another repository
  vim.api.nvim_create_autocmd("BufFilePost", {
    group = group,
    callback = function(args)
      vim.b[args.buf].status_git_root = nil
    end,
  })

  -- Redraw for state the render function reads but nothing else redraws for
  vim.api.nvim_create_autocmd({ "ModeChanged", "LspAttach", "LspDetach" }, {
    group = group,
    callback = function()
      vim.schedule(function() vim.cmd.redrawstatus() end)
    end,
  })

  -- Clear the command line 5s after leaving it
  local clear_timer = assert(vim.uv.new_timer())
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = function()
      clear_timer:stop()
      clear_timer:start(5000, 0, vim.schedule_wrap(function()
        vim.cmd("echon ' '")
      end))
    end,
  })

  -- Blank tabline: keeps a line of space above each window (same padding the
  -- old winbar gave, without the per-window bar)
  vim.o.showtabline = 2
  vim.o.tabline = " "
end

-- ============================================================
-- PLUGINS
-- ============================================================

-- -- mini.nvim --

vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
})

require("mini.pairs").setup()
require("mini.files").setup()
require("mini.icons").setup()
require("mini.extra").setup()

-- File explorer, opened at the current file
vim.keymap.set("n", "<leader>e", function()
  local path = vim.api.nvim_buf_get_name(0)
  require("mini.files").open(vim.uv.fs_stat(path) and path or nil)
end, { desc = "File Explorer" })

-- Pickers
require("mini.pick").setup({
  mappings = {
    move_down = '<C-j>',
    move_up = '<C-k>',
  }
})
vim.keymap.set('n', '<leader>sf', MiniPick.builtin.files, { desc = "Find file" })
vim.keymap.set('n', '<leader>sg', MiniPick.builtin.grep_live, { desc = "Grep" })
vim.keymap.set('n', '<leader>sb', MiniPick.builtin.buffers, { desc = "Buffers" })
vim.keymap.set('n', '<leader>sr', MiniExtra.pickers.oldfiles, { desc = "Recent files" })

do
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end

-- -- Treesitter --

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install({
  "bash", "c", "cpp", "go", "lua", "markdown", "markdown_inline",
  "php", "python", "query", "rust", "terraform", "vim", "vimdoc", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- -- Neogit --

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/neogitorg/neogit" },
})

require('neogit').setup({
  integrations = {
    diffview = true
  }
})

-- Magit-like keymaps
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'Neogit status' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<CR>', { desc = 'Neogit commit' })
vim.keymap.set('n', '<leader>gl', '<cmd>Neogit log<CR>', { desc = 'Neogit log' })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File history' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })

-- -- Mason --

vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup({
  PATH = "prepend",
})

-- Update with :MasonToolsUpdate
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "terraform-ls",
    "pyright",
    "gopls",
    "yaml-language-server",
  },
  run_on_start = false,
})
