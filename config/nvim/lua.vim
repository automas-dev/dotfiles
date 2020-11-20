let g:lua_syntax_nosymboloperator=1
let g:lua_syntax_fancynotequal=0

command! CMakeFindExeTargets lua require'cmakefindtargets'.findCMakeExeTarget

" Load lua code
"command! Scratch lua require'tools'.makeScratch()
"command! Scat luafile lua/tools.lua
"command! Rel w | source init.vim | Scat
"
"nnoremap <C-p> <Esc>:Rel<CR>

