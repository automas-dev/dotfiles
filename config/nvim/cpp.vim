
source ~/.config/nvim/cmake.vim

let g:cmake_generate_options=['-DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE', '-GNinja']
let s:cmake_last_executable = 0

let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

function! CMakeGenerate(...)
    let l:options = g:cmake_generate_options
    let l:options += a:000
    "!mkdir -p build; cd build; cmake .. -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
    "!cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE
    exec '!mkdir -p build; cmake -S . -B build ' . join(g:cmake_generate_options, ' ')
endfunction

function! CMakeBuild()
    :wa
    exec "!cmake --build build"
    return v:shell_error
endfunction

function! CMakeSelectExecutable()
    let l:targets = CMakeFindExecutableTargets()
    let l:i = 0
    for target in l:targets
        echo l:i . ") " . target
        let l:i = l:i + 1
    endfor
    let l:select = input("Select an executable(" . s:cmake_last_executable . "): ")
    if len(l:select) == 0
        let l:select = s:cmake_last_executable
    endif
    let s:cmake_last_executable = str2nr(l:select)
endfunction

function! CMakeRun()
    let l:targets = CMakeFindExecutableTargets()
    let l:target = l:targets[s:cmake_last_executable]
    exec "!cd build; [ -d " . l:target . " ] && cd " . l:target . "; ./" . l:target
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

command! -nargs=* CMakeGenerate call CMakeGenerate(<q-args>)
command! CMakeBuild call CMakeBuild()
command! CMakeSelectExecutable call CMakeSelectExecutable()
command! CMakeRun call CMakeRun()
command! CMakeBuildRun call CMakeBuildRun()
command! CMakeConfig e CMakeLists.txt

autocmd FileType c nnoremap <C-k>b :call CMakeBuild()<CR>
autocmd FileType c nnoremap <C-k><C-b> :call CMakeBuild()<CR>
autocmd FileType c nnoremap <F5> :CMakeBuildRun<CR>

autocmd FileType cpp nnoremap <C-k>b :call CMakeBuild()<CR>
autocmd FileType cpp nnoremap <C-k><C-b> :call CMakeBuild()<CR>
autocmd FileType cpp nnoremap <F5> :CMakeBuildRun<CR>

