set nocompatible
if has("gui_running")
    colorscheme zenburn
else
    colorscheme desert256
endif

filetype plugin on
filetype indent on

set ignorecase
set smartcase
set number
set scrolloff=1
set wrap
set nobackup
set noswapfile
set cursorline
set cino=:0,l1,g0,t0
set autochdir
set clipboard=unnamed
set tags=tags;
set ai
set si
set ts=4
set sw=4
set sts=4
set expandtab
set ttimeoutlen=100
set tw=80
set showmatch
set showcmd
set fo+=nl1
set nojoinspaces "Do not join lines with 2 spaces (just 1 is good enough)
set hlsearch
set matchtime=1 "Quickly show matching parens
set spellfile=~/.vim/dict.add

syntax on

:noremap <silent> <C-N> :noh<CR>
:noremap <silent> <C-]> <C-W><C-]>
:noremap <silent> <C-> <C-]>

:imap <C-L> gqap
:map <C-L> gqap

:noremap <silent> <SPACE> <PAGEDOWN>
:noremap <silent> <S-SPACE> <PAGEUP>
:noremap <silent> <S-j> <C-E>
:noremap <silent> <S-k> <C-Y>
:noremap <silent> <C-L> <C-W>>
:noremap <silent> <C-H> <C-W><

:noremap <silent> <tab> gt
:noremap <silent> <S-tab> gT

map <F5> :!ctags -R .<CR>

" Omni
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_NamespaceSearch = 1
let OmniCpp_ShowPrototypeInAbbr = 0
let OmniCpp_SelectFirstItem = 2
" Close preview window after unfocus
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
