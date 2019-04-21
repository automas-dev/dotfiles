"
" ~/.vimrc
"


"  _____ _                                __     ___           ____   ____ 
" |_   _| |__   ___  _ __ ___   __ _ ___  \ \   / (_)_ __ ___ |  _ \ / ___|
"   | | | '_ \ / _ \| '_ ` _ \ / _` / __|  \ \ / /| | '_ ` _ \| |_) | |    
"   | | | | | | (_) | | | | | | (_| \__ \  _\ V / | | | | | | |  _ <| |___ 
"   |_| |_| |_|\___/|_| |_| |_|\__,_|___/ (_)\_/  |_|_| |_| |_|_| \_\\____|

set nocompatible

" Import file type plugins and indentation
filetype plugin on
filetype indent on

" Enable syntax highlighting
syntax on

set foldmethod=syntax

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

" Fuzzy Find
set path+=**
set wildmenu
set wildmode=full

" Show matching brackets when cursor is over one
set showmatch

" Set UTF8 as the standard encoding
set encoding=utf8

" Persistent  undo
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.vim/undo
endif

" Diff with disk
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Latex flavor
let g:tex_flavor = "plain"

" Color Column (Print Margin)
set cc=81
highlight ColorColumn ctermbg=darkgray guibg=darkgray

" Add line numbers
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

"  _  __           __  __                _           
" | |/ /___ _  _  |  \/  |__ _ _ __ _ __(_)_ _  __ _ 
" | ' </ -_) || | | |\/| / _` | '_ \ '_ \ | ' \/ _` |
" |_|\_\___|\_, | |_|  |_\__,_| .__/ .__/_|_||_\__, |
"           |__/              |_|  |_|         |___/ 

" Set a leader character used as <leader>
let mapleader = ","

" Toggle spell check
map <leader>ss :setlocal spell!<cr>
map <leader>st :syntax spell toplevel<cr>

" Figlet banners
map <leader>fb :read !figlet -f big 
map <leader>fn :read !figlet -f standard 
map <leader>fs :read !figlet -f small 

" Latex math wrap binding
map <leader>mi xi\\(\\)<ESC>hhhp
map <leader>mm xi\\[\\]<ESC>hhhp

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

" Write and Test
cmap wt<CR> w<CR>:!/.test<CR>

" MK build system
cmap mk<CR> w<CR>:!mk<CR>

" Line Movement
nmap <C-down> <End>vk<End>xj<End>pj<End>
nmap <C-up> <End>vk<End>xk<End>pj<End>

" Nerd Tree
nmap <C-o> :NERDTreeToggle<CR>
imap <C-o> <Esc>:NERDTreeToggle<CR>

" Auto indent and Trim trailing whitespace
" nnoremap <C-F> gg=G<BAR>:let _s=@/ <BAR>:%s/\s\+$//e<BAR>:let @/=_s<BAR><CR>

" Smart Home
nnoremap <Home> ^

set laststatus=2
:let g:buftabs_in_statusline=1
:let g:buftabs_only_basename=1

" buftabs nav
noremap <C-left> :bprev<CR>
noremap <C-right> :bnext<CR>

" Clang-format
" map <C-f> :pyf /usr/share/clang/clang-format.py<CR>

function! FormatFile()
	let save_pos = getpos(".")
	normal! gg=G
	call setpos('.', save_pos)
endfunction

nmap <C-f> :call FormatFile()<CR>
imap <C-f> <ESC>:call FormatFile()<CR>a

autocmd FileType c setlocal equalprg=clang-format
autocmd FileType c++ setlocal equalprg=clang-format
autocmd FileType python setlocal equalprg=autopep8\ -
autocmd FileType rust setlocal equalprg=rustfmt

" Autopep8
" au FileType python setlocal formatprg=autopep8\ -

"autocmd FileType python map <C-M> <ESC>idef main():<CR>pass<CR><HOME><CR><CR>if __name__ == "__main__":<CR>try:<CR>main()<CR><BS>except KeyboardInterrupt:<CR>print("Exiting!")<CR><ESC>8k<END>v3hda

