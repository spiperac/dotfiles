--------------------
-- Theme settings
-- -----------------
vim.pack.add({
  "https://github.com/vague2k/vague.nvim", -- Vague theme
})

require("vague").setup({})
vim.cmd("colorscheme vague")

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
