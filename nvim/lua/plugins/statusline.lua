-- Import required modules
local devicons = require("nvim-web-devicons")

-- Helper function to get the current mode with dynamic colors
local function get_mode()
  local modes = {
    ["n"] = { " NORMAL", "StatusModeNormal" },
    ["i"] = { " INSERT", "StatusModeInsert" },
    ["R"] = { " REPLACE", "StatusModeReplace" },
    ["v"] = { " VISUAL", "StatusModeVisual" },
    ["V"] = { " V-LINE", "StatusModeVisual" },
    ["c"] = { " COMMAND", "StatusModeCommand" },
  }
  local mode = modes[vim.fn.mode()] or { "OTHER", "StatusModeOther" }
  return string.format("%%#%s# %s %%*", mode[2], mode[1])
end

-- Helper function to get Git branch
local function get_git_branch()
  local branch = vim.b.gitsigns_head or ""
  if branch ~= "" then
    return " " .. branch
  end
  return ""
end

-- Helper function to get LSP diagnostics with colors
local function get_lsp_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  local counts = { errors = 0, warnings = 0, hints = 0, infos = 0 }

  for _, diag in pairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif diag.severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif diag.severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    elseif diag.severity == vim.diagnostic.severity.INFO then
      counts.infos = counts.infos + 1
    end
  end

  -- Group icons together with individual colors and unified black background
  return table.concat({
    " %#StatusDiagnosticsBg#",
    string.format("%%#StatusError# %d ", counts.errors),
    string.format("%%#StatusWarn# %d ", counts.warnings),
    string.format("%%#StatusHint# %d ", counts.hints),
    string.format("%%#StatusInfo# %d ", counts.infos),
    "%*"
  }, "")
end


-- Helper function to get file info
local function get_file_info()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    return "No Name"
  end

  -- Get icon and color
  local icon, icon_color = devicons.get_icon_color(filename, vim.bo.filetype, { default = true })
  icon = icon or ""
  icon_color = icon_color or "#ffffff" -- Default to white if color is nil

  return string.format("%%#StatusFileIcon#%s%%* %%#StatusFileName#%s [%s]",
    icon, filename, vim.bo.filetype or "none")
end

-- Define the statusline
function StatusLine()
  -- Skip statusline for Neo-tree
  local excluded_filetypes = { "neo-tree", "NvimTree", "toggleterm" }
  if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
    return " " -- Empty statusline for Neo-tree
  end

  -- Left: Mode and Git branch
  local left = string.format("%s %s ", get_mode(), get_git_branch())

  -- Center: File info and LSP diagnostics
  local center = string.format("%%#StatusFileName# %%=%s%s", get_file_info(), get_lsp_diagnostics())

  -- Right: Encoding and cursor position
  local encoding = vim.bo.fileencoding or vim.o.encoding
  local position = "%l:%c/%L"
  local right = string.format(" %s | %s ", encoding, position)

  return table.concat({ left, center, right })
end

-- Apply the statusline globally on startup
vim.o.statusline = "%!v:lua.StatusLine()"

-- Dynamically set statusline per window
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "BufEnter" }, {
  callback = function()
    local excluded_filetypes = { "neo-tree", "NvimTree" }
    if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
      vim.opt_local.statusline = " "
    else
      vim.opt_local.statusline = "%!v:lua.StatusLine()"
    end
  end,
})

-- Define highlights for dynamic components
vim.cmd([[
  highlight StatusDiagnostics guifg=#ffffff guibg=#000000 gui=bold
  highlight StatusFileName guifg=#ffffff guibg=#000000 gui=bold
  
  highlight StatusModeNormal guifg=#ffffff guibg=#005f87
  highlight StatusModeInsert guifg=#ffffff guibg=#005f5f
  highlight StatusModeReplace guifg=#ffffff guibg=#870000
  highlight StatusModeVisual guifg=#ffffff guibg=#87005f
  highlight StatusModeCommand guifg=#ffffff guibg=#5f00af
  highlight StatusModeOther guifg=#ffffff guibg=#444444

  highlight StatusError guifg=#ff5f5f guibg=NONE gui=bold
  highlight StatusWarn guifg=#ffff87 guibg=NONE gui=bold
  highlight StatusHint guifg=#5fd7ff guibg=NONE gui=bold
  highlight StatusInfo guifg=#5fff5f guibg=NONE gui=bold

  highlight StatusFileIcon guifg=#ffaf00 guibg=NONE
  highlight StatusFileName guifg=#ffffff guibg=NONE

  " Fallback for terminals without true color support
  if !has("gui_running") && !&termguicolors
    set termguicolors
  endif
]])
