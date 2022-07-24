
function! CargoBuild()
    :wa
    !cargo build
endfunction

function! CargoBuildRun()
    :wa
    !cargo build && cargo run
endfunction

command! CargoBuild call CargoBuild()
command! CargoRun !cargo run
command! CargoBuildRun !cargo build && cargo run
command! CargoConfig e Cargo.toml

autocmd FileType rust nnoremap <C-k>b :CargoBuild<CR>
autocmd FileType rust nnoremap <C-k><C-b> :CargoBuild<CR>
autocmd FileType rust nnoremap <F5> :CargoBuildRun<CR>

