local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Set header with some ASCII art or text
dashboard.section.header.val = {
    [[     _   _             _              ]],
    [[    | |_| |_ _ __  ___| |_ ___  _ __  ]],
    [[    | __| __| '_ \/ __| __/ _ \| '_ \ ]],
    [[    | |_| |_| | | \__ \ || (_) | | | |]],
    [[     \__|\__|_| |_|___/\__\___/|_| |_|]],
}
dashboard.section.header.opts.hl = "Title"

-- Add buttons for common actions
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}

-- Footer section (optional)
dashboard.section.footer.val = "Welcome to Neovim!"
dashboard.section.footer.opts.hl = "Comment"

alpha.setup(dashboard.opts)
