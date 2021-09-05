let mapleader = ","

" Spell check
nnoremap <leader>ss :setlocal spell!<CR>
nnoremap <leader>st :syntax spell toplevel<CR>

" Line Movement
function! ShiftLineUp()
    if line('.') > 1
        normal ddkP
    endif
endfunction

function! ShiftLineDown()
    normal ddp
endfunction

nnoremap <C-down> :call ShiftLineDown()<CR>
nnoremap <C-up> :call ShiftLineUp()<CR>

" Smart Home
inoremap <Home> <Esc>^i
nnoremap <Home> ^

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Open new split / vsplit
nnoremap <leader>n :split<CR>
nnoremap <leader>v :vsplit<CR>

" Figlet banners
nnoremap <leader>fb :read !figlet -f big
nnoremap <leader>fn :read !figlet -f standard
nnoremap <leader>fs :read !figlet -f small

" Write as sudo
cnoremap w! w !sudo tee > /dev/null %

" buftabs nav
noremap <C-left> :bprev<CR>
noremap <C-right> :bnext<CR>

command! Rewrap normal {v}gq

" Re-wrap paragraph
noremap <A-q> :Rewrap<CR>
noremap <C-k><C-q> :Rewrap<CR>

" Map :W to :w
command! W w

" Toggle wrap with ,w
nnoremap <leader>w :set wrap!<CR>

command! RemoveWhitespace :%s/\s\+$//e

" Remove trailing whitespace
nnoremap <leader>sw :RemoveWhitespace<CR>
nnoremap <C-k><C-s> :RemoveWhitespace<CR>


command! GenBuild exec "![ -f build ] && ./build || ./%"
command! GenRun exec "![ -f run ] && ./run || ./%"
command! GenBuildRun exec "![ -f build ] && ./build || [ -f run ] && ./run || ./%"

" Generic build and run scripts
nnoremap <C-k>b :wa <CR> :GenBuild<CR>
nnoremap <C-k><C-b> :wa<CR> :GenBuild<CR>
nnoremap <F5> :wa<CR> :GenBuildRun<CR>

" Auto close

"function! AutoClose(close)
"    let l:next = strcharpart(getline('.')[col('.'):], 0, 1)
"    if l:next == a:close
"        exec "normal! la"
"    else
"        exec "normal! a".a:close
"    endif
"endfunction
"
"inoremap "<ESC> "
"inoremap " ""<left>
"inoremap '<ESC> '
"inoremap ' ''<left>
"inoremap (<Esc> (
"inoremap ( ()<left>
"inoremap ) <ESC>:call AutoClose(")")<CR>a
"inoremap () ()
"inoremap [<Esc> [
"inoremap [ []<left>
"inoremap ] <ESC>:call AutoClose("]")<CR>a
"inoremap [] []
"inoremap {<Esc> {
"inoremap { {}<left>
"inoremap } <ESC>:call AutoClose("}")<CR>a
"inoremap {} {}
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

"inoremap "<ESC> "
"inoremap " <ESC>:call AutoClose( "\"")<CR>a
"inoremap '<ESC> '
"inoremap ' <ESC>:call AutoClose("'")<CR>a
"inoremap (<Esc> (
"inoremap ( ()<left>
"inoremap ) <ESC>:call AutoClose(")")<CR>a
"inoremap [<Esc> [
"inoremap [ []<left>
"inoremap ] <ESC>:call AutoClose("]")<CR>a
"inoremap {<Esc> {
"inoremap { {}<left>
"inoremap } <ESC>:call AutoClose("}")<CR>a
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O
