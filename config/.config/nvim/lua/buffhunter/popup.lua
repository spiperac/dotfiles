-- buffhunter/popup.lua
local M = {}

-- Global variables
local selected_line = 1
local buffers = {}
local popup_win = nil
local popup_buf = nil
local original_win = nil

-- Update the get_file_icon function to handle both color codes and highlight groups
local function get_file_icon(filename)
    local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
    if has_devicons then
        local extension = filename:match("^.+%.(.+)$") or ""
        local icon, icon_hl = devicons.get_icon(filename, extension, { default = true }) 
        -- Handle nil icon_hl case
        local color = "#61afef"  -- Default fallback color
        if icon_hl then
            local hl_info = vim.api.nvim_get_hl(0, { name = icon_hl })
            color = hl_info and hl_info.fg and string.format("#%06x", hl_info.fg) or color
        end
        -- print(icon, icon_hl, color)
        
        return icon or "", color
    end
    return "", "#ffffff"  -- Default fallback for no devicons
end


local function get_git_status(bufnr)
    local has_gitsigns, gitsigns = pcall(require, 'gitsigns')
    if has_gitsigns then
        local signs = vim.fn.sign_getplaced(bufnr, {group = 'gitsigns'})[1]
        if signs and signs.signs and #signs.signs > 0 then
            local sign = signs.signs[1].name
            if sign:match("GitSignsAdd") then
                return "●", "#98c379"  -- green for added
            elseif sign:match("GitSignsChange") then
                return "●", "#e5c07b"  -- yellow for modified
            elseif sign:match("GitSignsDelete") then
                return "●", "#e06c75"  -- red for deleted
            end
        end
        return "●", "#565c64"  -- gray for committed/unchanged
    end
    return "", "#ffffff"
end

local function setup_highlights()
    vim.api.nvim_set_hl(0, "BufferNumber", { fg = "#61afef", bold = true })
    vim.api.nvim_set_hl(0, "BufferIcon", { default = true })
    vim.api.nvim_set_hl(0, "BufferPath", { fg = "#abb2bf" })
    vim.api.nvim_set_hl(0, "BufferGitStatus", { default = true })
end

-- Function to open a popup window and display buffers
M.open = function()
    original_win = vim.api.nvim_get_current_win()
    buffers = vim.fn.getbufinfo({ buflisted = 1 })
    
    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    popup_buf = vim.api.nvim_create_buf(false, true)
    
    -- Modified window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        style = "minimal",
        zindex = 50  -- Ensure window is on top
    }
    
    popup_win = vim.api.nvim_open_win(popup_buf, true, opts)
    -- Ensure termguicolors is globally enabled for proper color support
    vim.o.termguicolors = true
    
    -- Set window-specific options to ensure colors work
    vim.wo[popup_win].winhl = 'Normal:Normal'  -- Use normal highlighting
    vim.wo[popup_win].winblend = 0  -- No transparency
    vim.api.nvim_win_set_option(popup_win, 'wrap', false)

    -- Rest of your existing code...
    setup_highlights()

    local lines = {}
    local highlights = {}
    local namespace = vim.api.nvim_create_namespace('buffhunter')
    
    for i, buf in ipairs(buffers) do
        local icon, icon_color = get_file_icon(buf.name)
        local git_status, git_color = get_git_status(buf.bufnr)
        
        local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":~:.") or "[No Name]"
        local padding = width - #name - #icon - 8
        if padding < 0 then padding = 0 end
        
        local line = string.format("%2d %s %s%s%s", 
            buf.bufnr, 
            icon, 
            name,
            string.rep(" ", padding),
            git_status
        )
        table.insert(lines, line)
        
        -- Create highlight groups
        local icon_hl = string.format("BuffIcon_%d", i)
        local git_hl = string.format("BuffGit_%d", i)
        

        table.insert(highlights, {
            { "BufferNumber", i - 1, 0, 2 },
            { icon_hl, i - 1, 3, 3 + #icon },
            { "BufferPath", i - 1, 3 + #icon, 3 + #icon + #name },
            { git_hl, i - 1, #line - #git_status, #line }
        })
    end

    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, #lines > 0 and lines or { "No buffers available" })

    -- Apply highlights with namespace
    for _, hl_group in ipairs(highlights) do
        for _, hl in ipairs(hl_group) do
            vim.api.nvim_buf_add_highlight(popup_buf, namespace, hl[1], hl[2], hl[3], hl[4])
        end
    end

    -- Set keymaps
    local keymap_opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'k', [[<cmd>lua require('buffhunter.popup').move_selection(-1)<CR>]], keymap_opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'j', [[<cmd>lua require('buffhunter.popup').move_selection(1)<CR>]], keymap_opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<CR>', [[<cmd>lua require('buffhunter.popup').open_selected_buffer()<CR>]], keymap_opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'q', [[<cmd>lua require('buffhunter.popup').close()<CR>]], keymap_opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Esc>', [[<cmd>lua require('buffhunter.popup').close()<CR>]], keymap_opts)

    M.highlight_selection()
    vim.cmd("redraw") --
end

M.highlight_selection = function()
    if popup_buf then
        vim.api.nvim_buf_clear_namespace(popup_buf, -1, 0, -1)
        vim.api.nvim_buf_add_highlight(popup_buf, 0, 'IncSearch', selected_line - 1, 0, -1)
    end
end

M.move_selection = function(direction)
    if #buffers > 0 then
        selected_line = math.max(1, math.min(selected_line + direction, #buffers))
        M.highlight_selection()
    end
end

M.close = function()
    if popup_win and vim.api.nvim_win_is_valid(popup_win) then
        vim.api.nvim_win_close(popup_win, true)
    end
    popup_win = nil
    popup_buf = nil
end

M.toggle = function()
    if popup_win and vim.api.nvim_win_is_valid(popup_win) then
        vim.api.nvim_win_close(popup_win, true)
        popup_win = nil
        popup_buf = nil
    else
        M.open()
    end
end

M.open_selected_buffer = function()
    if #buffers > 0 then
        local selected_bufnr = buffers[selected_line].bufnr
        
        -- Check if original window is still valid
        if original_win and vim.api.nvim_win_is_valid(original_win) then
            -- Get the selected buffer before closing popup
            local selected_bufnr = buffers[selected_line].bufnr
            
            -- Close popup first
            M.close()
            
            -- Try to set the window and buffer
            pcall(function()
                vim.api.nvim_set_current_win(original_win)
                vim.api.nvim_set_current_buf(selected_bufnr)
            end)
        else
            -- Fallback: try to open in the current window
            M.close()
            pcall(vim.api.nvim_set_current_buf, selected_bufnr)
        end
    end
end

return M
