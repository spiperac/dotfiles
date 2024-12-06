-- buffhunter/popup.lua
local M = {}

-- Global variables
local selected_line = 1
local buffers = {}
local popup_win = nil
local popup_buf = nil
local original_win = nil  -- Store the original window ID

-- Function to open a popup window and display buffers
M.open = function()
    -- Store the window ID before creating popup
    original_win = vim.api.nvim_get_current_win()
    
    buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local lines = {}
    for _, buf in ipairs(buffers) do
        table.insert(lines, string.format("%d: %s", buf.bufnr, buf.name ~= "" and buf.name or "[No Name]"))
    end

    -- Popup dimensions
    local width = math.floor(vim.o.columns * 0.5)
    local height = math.floor(vim.o.lines * 0.4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create popup buffer and window
    popup_buf = vim.api.nvim_create_buf(false, true)
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded"
    }
    popup_win = vim.api.nvim_open_win(popup_buf, true, opts)

    -- Set lines in the popup
    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, #lines > 0 and lines or { "No buffers available" })

    -- Set buffer options
    vim.api.nvim_buf_set_option(popup_buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(popup_buf, 'bufhidden', 'wipe')

    -- Keymaps
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'k', [[<cmd>lua require('buffhunter.popup').move_selection(-1)<CR>]], opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'j', [[<cmd>lua require('buffhunter.popup').move_selection(1)<CR>]], opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<CR>', [[<cmd>lua require('buffhunter.popup').open_selected_buffer()<CR>]], opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'q', [[<cmd>lua require('buffhunter.popup').close()<CR>]], opts)
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Esc>', [[<cmd>lua require('buffhunter.popup').close()<CR>]], opts)

    -- Initial highlight
    M.highlight_selection()
end

-- Function to highlight the current selection
function M.highlight_selection()
    if popup_buf then
        vim.api.nvim_buf_clear_namespace(popup_buf, -1, 0, -1)
        vim.api.nvim_buf_add_highlight(popup_buf, 0, 'IncSearch', selected_line - 1, 0, -1)
    end
end

-- Function to move selection
M.move_selection = function(direction)
    if #buffers > 0 then
        selected_line = math.max(1, math.min(selected_line + direction, #buffers))
        M.highlight_selection()
    end
end

-- Function to close the popup
M.close = function()
    if popup_win and vim.api.nvim_win_is_valid(popup_win) then
        vim.api.nvim_win_close(popup_win, true)
    end
    popup_win = nil
    popup_buf = nil
end

-- Function to open the selected buffer
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
