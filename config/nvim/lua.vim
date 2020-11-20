let g:lua_syntax_nosymboloperator=1
let g:lua_syntax_fancynotequal=0

function! CMakeFindExeTargets()
    let l:targets = luaeval('require("cmakefindtargets").findCMakeExeTarget()')
    "echo l:targets
    return l:targets
endfunction

