" Common config
set linespace=0
set number

" Plugins vim-plug
" Auto install plug-vim and all of the plugins when you first time open nvim
"
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" List your plugins here

Plug 'akinsho/toggleterm.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'lewis6991/gitsigns.nvim'

" Themes and fonts and icons
" nui.nvim is required by neo-tree
Plug 'rafi/awesome-vim-colorschemes'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Non-mandatory plugs ( but nice to have)
Plug 'nvim-telescope/telescope.nvim'
Plug 'ahmedkhalf/project.nvim'
Plug 'goolord/alpha-nvim'

call plug#end()

" Plugin config

" Theme
colorscheme gruvbox
" let g:neovide_transparency = 1.0

" Require lua configs
lua require('settings')
let g:neovide_scale_factor=1.0

" Keymaps
nmap <C-n> :Neotree toggle<CR>
nnoremap <leader>e :NeoTreeFocusToggle<CR>
nnoremap <leader>t :ToggleTerm<CR>
nnoremap <S-l> :BufferLineCycleNext<CR>
nnoremap <S-h> :BufferLineCyclePrev<CR>
nnoremap <ESC>u :nohlsearch<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use Tab for completion navigation
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Confirm completion with Enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
