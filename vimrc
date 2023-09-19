" Basic settings
set nocompatible              " required
filetype off                  " required
set mouse=a                   " Enable mouse integration
set showmatch                 " Highlight matching brackets
set autoindent
set copyindent
set hlsearch
set incsearch
set number
set history=1000
set undolevels=1000
set title
set visualbell
set noerrorbells
set nobackup
set noswapfile

" Plugins installation
call plug#begin()

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

Plug 'tomtom/tcomment_vim'
Plug 'airblade/vim-gitgutter'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()           " required

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set nu
set clipboard=unnamed

" Set theme
colorscheme dracula

" NERDTree ignore
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

set encoding=utf-8
set splitbelow
set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" PEP8 
let python_highlight_all=1
syntax on

au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" ----- Custom Bindings ------
" Leader - \
" C - Ctrl

" Autocomplete
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" File Explorer
map <C-n> :NERDTreeToggle<CR>

" Highlight current line
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" Show powerline always
set laststatus=2

