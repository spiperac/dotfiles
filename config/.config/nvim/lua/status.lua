----------------------
--- Status Line
----------------------
vim.opt.laststatus = 3
local cached_branch = ""

-- Update statusline function
local function active_statusline()
  -- Get Git Branch if any
  local branch = cached_branch ~= "" and cached_branch or
      vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
  if vim.v.shell_error ~= 0 then
    branch = ""
  end

  local git_icon = ' ' -- e0a0
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local lsp_server = (clients[1] and clients[1].name) or "none"

  -- Mode
  local mode = vim.fn.mode()
  local mode_part = ""
  if mode == "n" then
    mode_part = "%#GitStatus# NORMAL %*"
  elseif mode == "i" then
    mode_part = "%#StatusInsert# INSERT %*"
  elseif mode:match("[vV]") or mode == "\22" then
    mode_part = "%#StatusVisual# VISUAL %*"
  elseif mode == "R" then
    mode_part = "%#StatusReplace# REPLACE %*"
  elseif mode == "c" then
    mode_part = "%#StatusCommand# COMMAND %*"
  else
    mode_part = "%#StatusNormalHL# " .. mode:upper() .. " %*"
  end

  -- Branch
  local branch_formatted = ""
  if branch ~= "" then
    local git_status = vim.fn.system("git status --porcelain 2>/dev/null")
    local status_color = "%#GitClean#"
    if git_status ~= "" then
      status_color = "%#GitDirty#"
    elseif vim.fn.system("git log --oneline @{u}..HEAD 2>/dev/null") ~= "" then
      status_color = "%#GitAhead#"
    end
    branch_formatted = status_color .. git_icon .. branch .. "%* "
    -- branch_formatted = "%#GitStatus# " .. git_icon .. branch .. " %* "
  end

  -- Filename
  local ft = vim.bo.filetype

  local full = vim.fn.expand("%:p")
  local name = vim.fn.fnamemodify(full, ":t")
  local parent = vim.fn.fnamemodify(full, ":p:h:t")
  local filename = name .. " · " .. parent
  local mod = vim.bo.modified and " [+]" or ""

  local ok, icons = pcall(require, 'mini.icons')
  local icon = "📄"
  if ok then
    local s, i = pcall(icons.get, "filetype", ft)
    if s and i then icon = i end
  end
  local hl_file = vim.bo.modified and "%#ModifiedHL#" or "%#GreenLetters#"
  local status_file = " " .. icon .. " " .. hl_file .. filename .. "%* %p%% " .. "%#ModifiedHL#" .. mod .. "%*"


  vim.wo.statusline = mode_part ..
      status_file ..
      " %=" ..
      "%#StatusLsp#LSP:" ..
      lsp_server ..
      "%* %{&filetype}/%{&fenc}  " ..
      branch_formatted .. "  "
end


-- Update gitbranch on dir changes
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if vim.v.shell_error ~= 0 then
      cached_branch = ""
    end
    active_statusline()
  end,
})

-- Update on buffer enter or LSP attach
vim.api.nvim_create_autocmd(
  { "WinEnter", "BufWinEnter", "BufEnter", "LspAttach", "ModeChanged", "BufWritePost",
    "VimResized", "TextChanged" }, {
    callback = active_statusline
  })

-- Clear cmd line after 5000ms
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    vim.fn.timer_start(5000, function()
      vim.cmd [[ echon ' ' ]]
    end)
  end
})

-- File name and icon in WinBar
_G.get_winbar_icon = function()
  local ft = vim.bo.filetype
  local filename = "%t" -- vim.fn.pathshorten(vim.fn.expand("%:."))

  local mod = vim.bo.modified and " [+]" or ""

  local ok, icons = pcall(require, 'mini.icons')
  local icon = "📄"
  if ok then
    local s, i = pcall(icons.get, "filetype", ft)
    if s and i then icon = i end
  end
  local hl_file = vim.bo.modified and "%#ModifiedHL#" or ""
  return " "
  -- return "  " .. icon .. " " .. hl_file .. filename .. "%* " .. "%#ModifiedHL#" .. mod .. "%*"
end

vim.opt.winbar = "  %{%v:lua.get_winbar_icon()%}"
