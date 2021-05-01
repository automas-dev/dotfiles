
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1

autocmd FileType c nnoremap <C-k>b :CMakeBuild<CR>
autocmd FileType c nnoremap <C-k><C-b> :CMakeBuild<CR>
autocmd FileType c nnoremap <C-k><C-t> :CMakeTest<CR>
autocmd FileType c nnoremap <F5> :CMakeBuildRun<CR>

autocmd FileType cpp nnoremap <C-k>b :CMakeBuild<CR>
autocmd FileType cpp nnoremap <C-k><C-b> :CMakeBuild<CR>
autocmd FileType cpp nnoremap <C-k><C-t> :CMakeTest<CR>
autocmd FileType cpp nnoremap <F5> :CMakeBuildRun<CR>

