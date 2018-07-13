" Import file type plugins and indentation
filetype plugin on
filetype indent on

" Enable syntax highlighting
syntax on

" Set tab size to 4 spaces
set tabstop=4
set shiftwidth=4

" Enable mouse
set mouse=a

" Set a leader character used as <leader>
let mapleader = ","

" Ignore case while searching
set ignorecase

" Enable regular expressions
set magic

" Show matching brackets when cursor is over one
set showmatch

" Set UTF8 as the standard encoding
set encoding=utf8

" Pressing ,ss will toggle spell check
map <leader>ss :setlocal spell!<cr>

" Write as sudo
cmap W w !sudo tee > /dev/null %

" ,b will run the build script
map <leader>b !./build

" ,r will run the run script
map <leader>r !./run

map <F5> :w<CR>:!./build && ./run<CR>

" Write and build
cmap wb<CR> w<CR>:!./build<CR>

" Write and run
cmap wr<CR> w<CR>:!./run<CR>

