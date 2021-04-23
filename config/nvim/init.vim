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
    "Plug 'cdelledonne/vim-cmake'
    "Plug 'raspine/vim-target'

    " Toml
    Plug 'cespare/vim-toml'

    " Lua
    Plug 'twh2898/vim-lua'

    " GLSL
    Plug 'tikhomirov/vim-glsl'

    " Scarpet
    Plug 'twh2898/vim-scarpet'

    " Fugitive
    Plug 'tpope/vim-fugitive'
call plug#end()

set hidden

set nobackup
set nowritebackup

set updatetime=300

set shortmess+=c

let g:coc_global_extensions = ['coc-pyright', 'coc-rls', 'coc-snippets', 'coc-lua', 'coc-cmake', 'coc-git', 'coc-json', 'coc-sh', 'coc-xml', 'coc-html', 'coc-css', 'coc-yaml', 'coc-vimlsp']

let s:cwd = expand('<sfile>:p:h')
let s:deps = [
            \'base',
            \'colors',
            \'keys',
            \'macro',
            \'openterm',
            \'nerdtree',
            \'coc',
            \'snip',
            \'format',
            \'cpp',
            \'lua',
            \'rust',
            \'python',
            \]

for dep in s:deps
    call util#Requires(s:cwd, dep)
endfor

