-----------------
--- Settings
-----------------

-- General Settings
vim.opt.relativenumber = true
vim.opt.number = true           -- Enable line numbers
vim.o.linespace = 0             -- No additional spacing between lines
vim.opt.mouse = 'a'             -- Mouse support
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.termguicolors = true      -- Enable true color support
vim.opt.fileformats = "unix,dos"
vim.o.encoding = "UTF-8"
--vim.o.path = vim.o.path .. ",**"
vim.o.cmdheight = 1 -- Auto-hide command line

-- Spaces instead of tab
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 2   -- Number of spaces for indentation
vim.o.tabstop = 2      -- Number of spaces for a tab
vim.o.softtabstop = 2

-- Identations
vim.o.smartindent = true                       -- Smart auto-indenting
vim.o.breakindent = true
vim.opt.formatoptions:remove { "c", "r", "o" } --Disable auto comment new line

-- Splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- Cases, to help in searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Files
vim.opt.incsearch = true
vim.o.undofile = true
vim.o.autoread = true
vim.o.autowrite = false
vim.o.ttimeoutlen = 50
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Visual
vim.opt.winborder = 'rounded'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.showmatch = true
vim.o.signcolumn = "yes"
vim.opt.guicursor = "n-v-c:block-blinkwait500-blinkon500-blinkoff500"

-- Netrw settings
vim.g.netrw_banner = 0       -- hide banner
vim.g.netrw_liststyle = 3    -- tree-style listing
vim.g.netrw_winsize = 30     -- set width
vim.g.netrw_browse_split = 4 -- open in prior window
vim.g.netrw_fastbrowse = 0   -- Netrw fastbrowse off
vim.g.netrw_clipboard = 0

-- Auto commands

-- Fix for WSL clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.fn.setreg("+", vim.fn.substitute(vim.fn.getreg("+"), "\r\n", "\n", "g"))
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
})
