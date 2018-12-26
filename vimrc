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
set noexpandtab

" Enable mouse
set mouse=a

" Enable spell check
"set spell spelllang=en_us

" Ignore case while searching
set ignorecase

" Enable regular expressions
set magic

" Show matching brackets when cursor is over one
set showmatch

" Set UTF8 as the standard encoding
set encoding=utf8

" Persistent  undo
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.vim/undo
endif

" Latex flavor
let g:tex_flavor = "plain"

" Color Column (Print Margin)
set cc=81
highlight ColorColumn ctermbg=gray guibg=gray

"  _  __           __  __                _           
" | |/ /___ _  _  |  \/  |__ _ _ __ _ __(_)_ _  __ _ 
" | ' </ -_) || | | |\/| / _` | '_ \ '_ \ | ' \/ _` |
" |_|\_\___|\_, | |_|  |_\__,_| .__/ .__/_|_||_\__, |
"           |__/              |_|  |_|         |___/ 

" Set a leader character used as <leader>
let mapleader = ","

" Toggle spell check
map <leader>ss :setlocal spell!<cr>

" Figlet banners
map <leader>fb :read !figlet -f big 
map <leader>fn :read !figlet -f standard 
map <leader>fs :read !figlet -f small 

" Run ./build
map <leader>b !./build

" Run ./run
map <leader>r !./run

" Build and Run
map <F5> :w<CR>:!./build && ./run<CR>

" Write and quit
map <leader>w :wq<CR>

" Write as sudo
map <leader>W :w !sudo tee > /dev/null %

" Quit
map <leader>q :q<CR>

" Force quit
map <leader>Q :q!<CR>

" Write as sudo
cmap w! w !sudo tee > /dev/null %

" Write and Build
cmap wb<CR> w<CR>:!./build<CR>

" Write and Call
cmap wc<CR> w<CR>:!./%<CR>

" Write and Run
cmap wr<CR> w<CR>:!./run<CR>

" MK build system
cmap mk<CR> w<CR>:!mk<CR>

"autocmd FileType python map <C-M> <ESC>idef main():<CR>pass<CR><HOME><CR><CR>if __name__ == "__main__":<CR>try:<CR>main()<CR><BS>except KeyboardInterrupt:<CR>print("Exiting!")<CR><ESC>8k<END>v3hda

