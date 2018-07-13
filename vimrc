"
" ~/.vimrc
"


"  _____ _                                __     ___           ____   ____ 
" |_   _| |__   ___  _ __ ___   __ _ ___  \ \   / (_)_ __ ___ |  _ \ / ___|
"   | | | '_ \ / _ \| '_ ` _ \ / _` / __|  \ \ / /| | '_ ` _ \| |_) | |    
"   | | | | | | (_) | | | | | | (_| \__ \  _\ V / | | | | | | |  _ <| |___ 
"   |_| |_| |_|\___/|_| |_| |_|\__,_|___/ (_)\_/  |_|_| |_| |_|_| \_\\____|

" Import file type plugins and indentation
filetype plugin on
filetype indent on

" Enable syntax highlighting
syntax on


"  ___      _   _   _              
" / __| ___| |_| |_(_)_ _  __ _ ___
" \__ \/ -_)  _|  _| | ' \/ _` (_-<
" |___/\___|\__|\__|_|_||_\__, /__/
"                         |___/    

" Set tab size to 4 spaces
set tabstop=4
set shiftwidth=4

" Enable mouse
set mouse=a

" Enable spell check
set spell spelllang=en_us

" Ignore case while searching
set ignorecase

" Enable regular expressions
set magic

" Show matching brackets when cursor is over one
set showmatch

" Set UTF8 as the standard encoding
set encoding=utf8


"  _  __           __  __                _           
" | |/ /___ _  _  |  \/  |__ _ _ __ _ __(_)_ _  __ _ 
" | ' </ -_) || | | |\/| / _` | '_ \ '_ \ | ' \/ _` |
" |_|\_\___|\_, | |_|  |_\__,_| .__/ .__/_|_||_\__, |
"           |__/              |_|  |_|         |___/ 

" Set a leader character used as <leader>
let mapleader = ","

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

" Figlet banners
map <leader>fb :read !figlet -f big 
map <leader>fn :read !figlet -f standard 
map <leader>fs :read !figlet -f small 

