""""""""""""""""""""
" Vim Configuration
""""""""""""""""""""

""""""""""""
" Settings
""""""""""""
syntax on
set nocompatible
set number
set mouse=a
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set smartindent
set clipboard=unnamedplus
set relativenumber
set incsearch
set hlsearch
set ignorecase smartcase
set nobackup
set nowritebackup
set noswapfile
set noundofile

set termguicolors
colorscheme habamax
hi Normal ctermbg=NONE guibg=NONE
hi nonText ctermbg=NONE guibg=NONE
hi StatusLine guibg=#0f0f0f guifg=grey


filetype plugin indent on


"""""""""""""
" Status Line
"""""""""""""
function! ModeName() abort
    let l:m = mode()
    return l:m=='n'?'NORMAL':
           \ l:m=='i'?'INSERT':
           \ l:m=='v'?'VISUAL':
           \ l:m=='V'?'V-LINE':
           \ l:m==# "\<C-V>"?'V-BLOCK':'OTHER'
endfunction

set laststatus=2
set statusline=\ \%{ModeName()}\ \|\ %F%m%r%=%l:%c\ 

autocmd InsertLeave,InsertEnter * redrawstatus

"""""""""""""""""
" Fuzzy
""""""""""""""""
set wildmenu
set wildoptions=pum
set wildmode=noselect,full

set wildignore+=**/.git/**,**/__pycache__/**,**/venv/**,**/node_modules/**,**/dist/**,**/build/**,*.o,*.pyc,*.swp,**/target/**
set path=**

function! FuzzyFindFunc(cmdarg, cmdcomplete)
    return systemlist("rg --files --hidden -g '!.git' | rg --ignore-case " . shellescape(a:cmdarg))
endfunction

if executable('rg')
    set findfunc=FuzzyFindFunc
endif

function! s:GrepInFiles(term)
    cexpr systemlist('rg --vimgrep ' . shellescape(a:term))
    copen
endfunction

command! -nargs=1 GrepInFiles call s:GrepInFiles(<f-args>)


"""""""""""""""""
" Colors
"""""""""""""""""
highlight EndOfBuffer ctermfg=black guifg=gray

""""""""""""""""""
" Plugins
""""""""""""""""""

let s:plugin_dir = expand('~/.vim/plugged')
function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name

  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif

  execute 'set runtimepath+=' . fnameescape(path)
endfunction

" Plugins
" call s:ensure('junegunn/fzf')
" call s:ensure('junegunn/fzf.vim')


nnoremap <leader>fo :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

" Fix for WSL clipboard

function! s:CleanCR() abort
    %s/\r//g
endfunction

""""""""""""""
" Keybinds
""""""""""""""
let mapleader = " "

nnoremap <C-w><C-x> :qa!<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>q :close<CR>
nnoremap <leader>o <C-w>w
nnoremap <leader>cp :call <SID>CleanCR()<CR>
nnoremap <leader>f :find<space>
nnoremap <leader>s :GrepInFiles<space>
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>

