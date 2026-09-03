-- Add to your plugins
vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
})


-- Setup Python
require('dap').adapters.python = {
  type = 'executable',
  command = 'python3',
  args = { '-m', 'debugpy.adapter' },
}

require('dap').configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch current file",
    program = function() return vim.fn.expand('%:p') end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    console = 'integratedTerminal',
  },
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = function()
      return vim.fn.input('Path to file: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    console = 'integratedTerminal',
  },
  {
    type = 'python',
    request = 'launch',
    name = "Launch module",
    module = function()
      return vim.fn.input('Module name: ')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Django Debug',
    console = 'integratedTerminal',
    program = '${workspaceFolder}/manage.py', -- Path to your manage.py
    args = { 'runserver', '0.0.0.0:8000' },   -- Django command and arguments
    cwd = '${workspaceFolder}',
  },
}

-- Setup keybinds
vim.keymap.set('n', '<F5>', require 'dap'.continue, { desc = "Run program" })
vim.keymap.set('n', '<F10>', require 'dap'.step_over, { desc = "Step over/Next BP" })
vim.keymap.set('n', '<F11>', require 'dap'.step_into, { desc = "Step into" })
vim.keymap.set('n', '<F12>', require 'dap'.step_out, { desc = "Step out" })

vim.keymap.set('n', '<leader>db', require 'dap'.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dh', require 'dap.ui.widgets'.hover, { desc = "Hover Info" })
vim.keymap.set('n', '<leader>dp', require 'dap.ui.widgets'.preview, { desc = "Preview Info" })

vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)

vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

-- Quit dap with q or ESC
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-*',
  callback = function()
    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(0, true) end, { buffer = true })
  end
})
