" Enable Mouse
set mouse=a

"Text Folding
set foldmethod=syntax
set foldlevel=20

" Set Tab Size to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Text encoding (does nothing)
set encoding=UTF-8

" Light Numbers
set number

" Open new split panes to right and below
set splitright
set splitbelow

" Ignore case while searching
set ignorecase

" Persistent  undo
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.vim/undo
endif

