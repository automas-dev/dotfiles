let mapleader = ","

" Spell check
nnoremap <leader>ss :setlocal spell!<CR>
nnoremap <leader>st :syntax spell toplevel<CR>

" Line Movement
nnoremap <C-down> <End>vk<End>xj<End>pj<End>
nnoremap <C-up> <End>vk<End>xk<End>pj<End>

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

