function! FormatFile()
    let save_pos = getpos('.')
    normal! gg=G
    "%!astyle
    call setpos('.', save_pos)
endfunction

nnoremap <C-f> :call FormatFile()<CR>
inoremap <C-f> <Esc>:call FormatFile()<CR>a
nnoremap<C-k><C-d> :call FormatFile()<CR>

autocmd FileType c setlocal equalprg=astyle
autocmd FileType c++ setlocal equalprg=astyle
autocmd FileType cpp setlocal equalprg=astyle
autocmd FileType python setlocal equalprg=autopep8\ -
autocmd FileType rust setlocal equalprg=rustfmt

