
function! CargoBuild()
    :wa
    te cargo build
endfunction

function! CargoBuildRun()
    :wa
    te cargo build && cargo run
endfunction

command! CargoBuild call CargoBuild()
command! CargoRun te cargo run
command! CargoBuildRun te cargo build && cargo run
command! CargoConfig e Cargo.toml

autocmd FileType rust nnoremap <C-k>b :CargoBuild<CR>
autocmd FileType rust nnoremap <C-k><C-b> :CargoBuild<CR>
autocmd FileType rust nnoremap <F5> :CargoBuildRun<CR>

