" Common config
set linespace=0
set number

" Plugins vim-plug

call plug#begin()
" List your plugins here

Plug 'sheerun/vim-polyglot'
Plug 'akinsho/toggleterm.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'lewis6991/gitsigns.nvim'

" Themes and fonts
Plug 'rafi/awesome-vim-colorschemes'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Plugin config

" Theme
colorscheme minimalist
" let g:neovide_transparency = 1.0

" Require lua configs
lua require('settings')
lua require('statusline')
let g:neovide_scale_factor=1.0

" Keymaps
nmap <C-n> :Neotree toggle<CR>
nnoremap <leader>e :NeoTreeFocusToggle<CR>
nnoremap <leader>t :ToggleTerm<CR>
nnoremap <S-l> :BufferLineCycleNext<CR>
nnoremap <S-h> :BufferLineCyclePrev<CR>
nnoremap <ESC>u :nohlsearch<CR>

" Use Tab for completion navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Confirm completion with Enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"