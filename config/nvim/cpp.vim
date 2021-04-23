
let s:cwd = expand('<sfile>:p:h')
call util#Requires(s:cwd, 'cmake')

let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

command! -nargs=* CMakeGenerate call CMakeGenerate(<f-args>)
command! -nargs=? CMakeBuild call CMakeBuild(<f-args>)
command! -nargs=0 CMakeSelectExecutable call CMakeSelectExecutable()
command! -nargs=* CMakeRun call CMakeRun(<f-args>)
command! -nargs=* CMakeBuildRun call CMakeBuildRun('', <f-args>)
command! -nargs=0 CMakeConfig e CMakeLists.txt

autocmd FileType c nnoremap <C-k>b :CMakeBuild<CR>
autocmd FileType c nnoremap <C-k><C-b> :CMakeBuild<CR>
autocmd FileType c nnoremap <F5> :CMakeBuildRun<CR>

autocmd FileType cpp nnoremap <C-k>b :CMakeBuild<CR>
autocmd FileType cpp nnoremap <C-k><C-b> :CMakeBuild<CR>
autocmd FileType cpp nnoremap <F5> :CMakeBuildRun<CR>

