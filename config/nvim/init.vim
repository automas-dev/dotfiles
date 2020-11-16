"
" ~/.config/nvim/init.vim
"

call plug#begin("~/.vim/plugged")
    " Plugin Section

    " Themes
    Plug 'dracula/vim'
    Plug 'rakr/vim-one'
    Plug 'nightsense/carbonized'

    " NERDTree
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'

    " C++
    Plug 'neoclide/coc.nvim'
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    "Plug 'vhdirk/vim-cmake'
    Plug 'cdelledonne/vim-cmake'
    Plug 'raspine/vim-target'

    Plug 'cespare/vim-toml'
call plug#end()

source ~/.config/nvim/base.vim
source ~/.config/nvim/colors.vim
source ~/.config/nvim/keys.vim
source ~/.config/nvim/openterm.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/cpp.vim
source ~/.config/nvim/snip.vim

" Load lua code
command! Scratch lua require'tools'.makeScratch()
command! Scat luafile lua/tools.lua
command! Rel w | source init.vim | Scat

nnoremap <C-p> <Esc>:Rel<CR>

set hidden

set nobackup
set nowritebackup

set updatetime=300

set shortmess+=c

let g:coc_global_extensions = ['coc-snippets', 'coc-lua', 'coc-clangd', 'coc-cmake', 'coc-git', 'coc-json', 'coc-python', 'coc-sh', 'coc-todolist', 'coc-xml', 'coc-html', 'coc-css', 'coc-yaml']

