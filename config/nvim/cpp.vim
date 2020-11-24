
let g:cmake_generate_options=['-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE', '-GNinja']

let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

function! CMakeGenerate()
    !mkdir -p build; cd build; cmake .. -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
endfunction

function! CMakeBuild()
    :wa
    !cmake --build build
endfunction

function! CMakeRun()
    !cmake --build build
    let l:targets = CMakeFindExeTargets()
    exec "!cd build; [ -d " . l:targets[0] . " ] && cd " . l:targets[0] . "; ./" . l:targets[0]
endfunction

function! CMakeBuildRun()
    call CMakeBuild()
    call CMakeRun()
endfunction

command! CMakeGenerate call CMakeGenerate()
command! CMakeBuild call CMakeBuild()
command! CMakeRun call CMakeRun()
command! CMakeBuildRun call CMakeBuildRun()
command! CMakeConfig e CMakeLists.txt

autocmd FileType c nnoremap <C-k>b :call CMakeBuild()<CR>
autocmd FileType c nnoremap <C-k><C-b> :call CMakeBuild()<CR>
autocmd FileType c nnoremap <F5> :CMakeBuildRun<CR>

autocmd FileType cpp nnoremap <C-k>b :call CMakeBuild()<CR>
autocmd FileType cpp nnoremap <C-k><C-b> :call CMakeBuild()<CR>
autocmd FileType cpp nnoremap <F5> :CMakeBuildRun<CR>

