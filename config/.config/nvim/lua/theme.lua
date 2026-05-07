--------------------
-- Theme settings
-- -----------------
vim.pack.add({
  "https://github.com/metalelf0/black-metal-theme-neovim",
})

require("black-metal").setup({
  -- optional configuration here
})
require("black-metal").load()
vim.cmd("colorscheme bathory")

-- Highlight active winbar
vim.opt.guicursor = "n-v-c:block-blinkwait500-blinkon500-blinkoff500"

-- Define highlight groups
vim.cmd([[
  hi StatusLineNC   guifg=NONE
  hi StatusNormalHL  guifg=white
  hi StatusInsert guibg=green guifg=white
  hi StatusVisual guibg=orange guifg=#0f0f0f
  hi StatusLsp guifg=white guibg=NONE
  hi GitStatus    guifg=white
  hi GitClean guifg=#7fa563 guibg=NONE
  hi GitDirty guifg=#d8647e guibg=NONE
  hi GitAhead guifg=#f3be7c guibg=NONE
  hi LineCol      guifg=orange
  hi ModifiedHL guifg=#ffd700
  hi StatusReplace guibg=red guifg=white
  hi StatusCommand guibg=purple guifg=white
  hi WhiteLetters guifg=white
  hi GreenLetters guifg=#A8E6CF
  hi WinBar guibg=NONE guifg=#A8E6CF
  hi WinBarNC guibg=NONE guifg=grey
  hi PmenuKind  guifg=#FF5874
  hi PmenuExtra guifg=#82AAFF
]])
