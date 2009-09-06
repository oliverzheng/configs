set nocompatible
if has("gui_running")
    colorscheme zenburn
else
    colorscheme desert256
endif

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
set ts=4
set sw=4
set sts=4
set expandtab
set ttimeoutlen=100
set tw=80

set spellfile=~/.vim/dict.add

syntax on

:noremap <silent> <C-N> :noh<CR>
:noremap <silent> <C-]> <C-W><C-]>
:noremap <silent> <C-> <C-]>

:noremap <silent> <SPACE> <PAGEDOWN>
:noremap <silent> <S-SPACE> <PAGEUP>
:noremap <silent> <S-j> <C-E>
:noremap <silent> <S-k> <C-Y>
:noremap <silent> <C-L> <C-W>>
:noremap <silent> <C-H> <C-W><

:noremap <silent> <tab> gt
:noremap <silent> <S-tab> gT
