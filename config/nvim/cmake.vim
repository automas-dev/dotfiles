
let s:show_match_error = 1
let s:show_debug = 0

function! s:PathJoin(...)
    if a:0 == 0
        return ''
    endif

    let l:abs = a:1[0] == '/'
    let l:parts = copy(a:000)
    for l:i in range(a:0)
        let l:parts[l:i] = substitute(l:parts[l:i], '/$', '', '')
        let l:parts[l:i] = substitute(l:parts[l:i], '^/', '', '')
    endfor
    if l:abs
        let l:parts = ['/'] + l:parts
    endif
    return join(l:parts, '/')
endfunction

function! s:ReadFile(path)
    let l:lines = []
    for l:line in readfile(a:path)
        let l:line = trim(l:line)
        if empty(l:line) || l:line[0] == '#'
            continue
        else
            if l:line =~ '#'
                let l:line = trim(matchstr(l:line, '\v[^#]*'))
            endif
            let l:lines = add(l:lines, l:line)
        endif
    endfor
    return l:lines
endfunction

function! s:ArgsFromLine(line)
    let l:line = a:line
    if l:line =~ '('
        let l:cmd = matchstr(l:line, '\v\s*(\w+)\s*\(')
        let l:line = l:line[len(l:cmd):]
    endif
    if l:line =~ ')'
        let l:line = matchstr(l:line, '\v[^\)]*')
    endif
    return split(l:line)
endfunction

function! s:ParseCommands(lines)
    let l:i = 0
    let l:cmds = []
    while l:i < len(a:lines)
        let l:line = a:lines[l:i]

        " Get command name
        let l:match = matchstr(l:line, '\v\s*(\w+)\s*\(')
        if empty(l:match)
            if s:show_match_error
                echoerr 'Match failed to find start of call "'.l:line.'"'
            endif
            break
        endif
        let l:command = l:match[:-2]

        " Get command arguments
        let l:args = s:ArgsFromLine(l:line)
        while l:line !~ ')\s*$'
            let l:i += 1
            if l:i >= len(a:lines)
                break
            endif
            let l:line = a:lines[l:i]
            let l:args += s:ArgsFromLine(l:line)
        endwhile

        " Store command and arguments
        let l:cmds = add(l:cmds, [l:command, l:args])

        let l:i += 1
    endwhile
    return l:cmds
endfunction

function! s:ResolveVar(vars, value)
    let l:value = a:value

    let l:end = 0
    let l:pattern = '\v\$\{\w+\}'
    let [l:match, l:begin, l:end] = matchstrpos(a:value, l:pattern, l:end)

    while l:end > 0
        let l:var = l:match[2:-2]
        if has_key(a:vars, l:var)
            let l:val = a:vars[l:var]
            let l:value = substitute(l:value, l:match, l:val, 'g')
        else
            let l:val = '@!@' . l:var . '!@!'
            let l:value = substitute(l:value, l:match, l:val, 'g')
        endif

        let [l:match, l:begin, l:end] = matchstrpos(a:value, l:pattern, l:end)
    endwhile

    return l:value
endfunction

function! s:FindExeTargets(path, vars)
    if !filereadable(a:path)
        echoerr 'File "'.a:path.'" does not exist'
    endif

    let l:dir = substitute(a:path, 'CMakeLists.txt$', '', '')

    let l:lines = s:ReadFile(a:path)
    let l:cmds = s:ParseCommands(l:lines)

    let l:vars = copy(a:vars)
    let l:targets = []
    for l:cmd in l:cmds
        " TODO: Make a recursive parse commands function with variable resolve
        if s:show_debug
            echo "Found command (" a:path ") " l:cmd
        endif
        let l:command = l:cmd[0]
        let l:args = l:cmd[1]
        "let l:args = map(l:cmd[1], {_, val -> s:ResolveVar(l:vars, val)})
        if l:command == 'project'
            let l:vars['PROECT_NAME'] = s:ResolveVar(l:vars, l:args[0])
        elseif l:command == 'set'
            for l:i in range(len(l:args) - 1)
                let l:i += 1
                let l:args[l:i] = s:ResolveVar(l:vars, l:args[l:i])
            endfor
            if len(l:args) > 2
                let l:vars[l:args[0]] = join(l:args[1:], ' ')
            elseif len(l:args) == 2
                let l:vars[l:args[0]] = l:args[1]
            elseif len(l:args) == 1
                let l:vars[l:args[0]] = ''
            endif
        elseif l:command == 'add_executable'
            let l:target = s:ResolveVar(l:vars, l:args[0])
            let l:targets = add(l:targets, l:target)
        elseif l:command == 'add_subdirectory'
            let l:sub_targets = s:FindExeTargets(s:PathJoin(l:dir, l:args[0], 'CMakeLists.txt'), l:vars)
            let l:targets += l:sub_targets
        endif
    endfor

    return l:targets
endfunction

function! CMakeFindExecutableTargets(...)
    " Parameters: (path='.')
    if a:0 == 1
        let l:path = a:1
    else
        let l:path = '.'
    endif

    let l:path = s:PathJoin(l:path, 'CMakeLists.txt')

    let l:targets = s:FindExeTargets(l:path, {})
    for target in l:targets
        echo "Found target " target
    endfor
    return l:targets
endfunction
