
let g:cmake_generate_options=['-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE', '-GNinja']

let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

if has('vim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
endif
endfunction

xmap <leader>rn <Plug>(coc-rename)
nmap <leader>rn <Plug>(coc-rename)
nmap <C-k><C-r> <Plug>(coc-rename)

xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

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

function! CMakeRun(target)
    :CMakeBuild<CR>
    exe '!cd build/' . a:target . ' && ./' . a:target
endfunction

nnoremap <C-k>b :CMakeBuild<CR><Esc>
nnoremap <C-k><C-b> :CMakeBuild<CR>
"nnoremap <F5> :CMakeBuild<CR> :CMakeRun()<CR>
inoremap <F5> <Esc>:CMakeBuild<CR> <Esc>:exec . "!" . FindExeTarget()<CR>
nnoremap <F5> :CMakeBuild<CR> <Esc>:exec . "!" . FindExeTarget()<CR>

