
let s:cache_path = expand('~/.cache/vim')

function! util#Requires(cwd, dependency)
    let l:path = util#PathJoin(a:cwd, a:dependency.'.vim')
    exec 'source '.l:path
endfunction

function! s:StripPath(_, path)
    " Remove any leading or trailing /
    "
    " Parameter: path string the path to strip
    "
    " Return: the path with no leading or trailing /

    let l:tmp = substitute(a:path, '/$', '', '')
    let l:tmp = substitute(l:tmp, '^/', '', '')

    return l:tmp
endfunction

function! util#PathJoin(...)
    " Join any number of arguments with a /
    "
    " Parameters: ... string paths to join
    "
    " Return: the joined path

    " If no arguments, return an empty string
    if a:0 == 0
        return ''
    endif

    " Check if the path is absolute
    let l:abs = a:1[0] == '/'

    let l:parts = map(copy(a:000), function('s:StripPath'))
    let l:rel_path = join(l:parts, '/')

    if l:abs
        return '/' . l:rel_path
    else
        return l:rel_path
    endif
endfunction

function! util#SetCache(cache, workingdir, key, value)
    " Get a numeric value from a cache file. Usualy called with getcwd() as
    " `workingdir`.
    " 
    " Parameters:
    "   cache string the cache name
    "   workingdir string workspace to write to
    "   key string the key to write to
    "   value number the value to write

    let l:dir_path = util#PathJoin(s:cache_path, a:cache, a:workingdir)
    let l:file_path = util#PathJoin(l:dir_path, a:key)

    " Make sure the cache directory exists
    silent exec '!mkdir -p "'.l:dir_path.'"'

    " Write value to file
    call writefile([a:value], l:file_path)
endfunction

function! util#GetCache(cache, workingdir, key)
    " Get a value from a cache file. Usualy called with getcwd() as
    " `workingddir`.
    " 
    " Parameters:
    "   cache string the cache name
    "   workingdir string which workspace to read from
    "   key string the key to read from
    " 
    " Return: the value as a number

    let l:file_path = util#PathJoin(s:cache_path, a:cache, a:workingdir, a:key)

    " Check that the value exists
    if filereadable(l:file_path)

        " Read the first line
        let l:lines = readfile(l:file_path, '', 1)

        " If something was read
        if len(l:lines) > 0 && len(l:lines[0]) > 0

            " Make it a number and return
            return l:lines[0]
        endif
    else

        " Return default value
        return ''
    endif
endfunction
