
let g:cmake_generate_options=['-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE', '-GNinja']

let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

function! CMakeGenerate()
    !mkdir -p build; cd build; cmake .. -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
endfunction

function! CMakeBuild()
    :wa
    exec "!cmake --build build"
    return v:shell_error
endfunction

function! CMakeRun()
    let l:targets = CMakeFindExeTargets()
    exec "!cd build; [ -d " . l:targets[0] . " ] && cd " . l:targets[0] . "; ./" . l:targets[0]
    return v:shell_error
endfunction

function! CMakeBuildRun()
    let l:build_error = CMakeBuild()
    if l:build_error != 0
        echo "build_error ".l:build_error
        return l:build_error
    endif
    let l:run_error = CMakeRun()
    return l:run_error
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

