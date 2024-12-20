-- Settings and Themes

-- General Settings
vim.o.number = true -- Enable line numbers
vim.o.linespace = 0 -- No additional spacing between lines
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.termguicolors = true            -- Enable true color support

-- Spaces instead of tab
vim.o.expandtab = true                -- Use spaces instead of tabs
vim.o.shiftwidth = 2                  -- Number of spaces for indentation
vim.o.tabstop = 2                     -- Number of spaces for a tab
vim.o.softtabstop = 2

-- Identations
vim.o.smartindent = true              -- Smart auto-indenting
vim.o.autoindent = true               -- Maintain indentation level on new lines
vim.o.breakindent = true
vim.opt.formatoptions:remove("cro")   -- Disable auto-comment on new lines

-- Splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- Cases, to help in searching
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undofile = true
vim.o.scrolloff = 8
