local M = {}

M.setup = function()
  -- Define custom command :Bufferhunter
  vim.api.nvim_create_user_command('Bufferhunter', function() require("buffhunter.popup").toggle() end, { nargs = 0 })

  -- Keymap for Bufferhunter command
  vim.api.nvim_set_keymap('n', '<C-l>', ':Bufferhunter<CR>', { noremap = true, silent = true })
end

-- Expose functions globally
_G.move_selection = require("buffhunter.popup").move_selection
_G.open_selected_buffer = require("buffhunter.popup").open_selected_buffer

return M

