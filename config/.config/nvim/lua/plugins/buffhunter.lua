return function()
    require('buffhunter').setup {
      border = 'rounded',
      keymaps = {
        open = '<CR>',         -- Open selected buffer
        close = '<ESC>',           -- Close selected buffer
        delete = 'x',
        split_h = 's',         -- Open in horizontal split
        split_v = 'v',         -- Open in vertical split
      },
      git_signs = true,        -- Enable Git status display
    }
end
