
" Turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" Open terminal on Ctrl+n
function! OpenTerminal()
    split term://bash
    resize 10
endfunction
nnoremap <C-k>n :call OpenTerminal()<CR>

function! OpenVTerminal()
    vsplit term://bash
endfunction
nnoremap <C-n> :call OpenVTerminal()<CR>
nnoremap <C-k><C-n> : call OpenVTerminal()<CR>

