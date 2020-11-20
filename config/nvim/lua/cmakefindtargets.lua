local api = vim.api
local cmd = vim.api.nvim_command

local M = {}

-- TODO: search up to find root with .git/

local function copy(obj)
    if type(obj) ~= 'table' then
        return obj
    else
        local res = {}
        for k, v in pairs(obj) do
            res[copy(k)] = copy(v)
        end
        return res
    end
end

local function pathjoin(base, ...)
    local args = {...}
    local newpath = base:gsub('/?$', '')
    if #args > 0 then
        newpath = newpath .. '/' .. table.concat(args, '/') 
    end
    return newpath
end

local function cleanline(line)
    line = line:gsub('^%s+', '')
    local instring = false
    for i = 1, #line do
        local c = line:sub(i, i)
        if c == '"' then
            if i > 1 and line:sub(i-1, i-1) ~= '\\' then
                instring = not instring 
            end
        elseif c == '#' and not instring then
            return line:sub(1, i-1)
        end
    end
    return line
end

local function readfile(path)
    local fp = io.open(path, 'r')
    if fp then
        local lines = {}
        local line = fp:read('*l')
        while line do
            line = cleanline(line)
            if #line > 0 then
                table.insert(lines, line)
            end
            line = fp:read('*l')
        end
        fp:close()
        return lines
    else
        print('Failed to open file', path)
        return nil
    end
end

local p_space = "%s*"
local p_name = p_space.."(%w[%w_]*)"..p_space
local p_varname = p_space.."(%${" .. p_name .. "})"..p_space

local p_add_executable = "^add_executable%("
local p_add_subdirectory = "^add_subdirectory%("
local p_set = "^set%("

local function insertifmatch(tab, line, prefix)
    local match = {line:match(prefix..p_varname)}
    if match[1] then
        -- print('varname', match[1], match[2])
        table.insert(tab, match[1])
    else
        match = line:match(prefix..p_name)
        if match then
            -- print('name', match)
            table.insert(tab, match)
        else
            print(prefix .. " with no target")
        end
    end
end

local function isvar(text)
    text = text or ''
    local match = {text:match(p_varname)}
    return match[1] ~= nil
end

local function resolvevar(key, vars)
    if isvar(key) then
        key = key:match(p_name)
        local val = vars[key]
        if isvar(val) then
            local newval = resolvevar(val, vars)
            vars[key] = newval
        end
        return vars[key]
    else
        return key
    end
end

local function findCMakeTargets(path, vars)
    path = path or ''
    local file = pathjoin(path, 'CMakeLists.txt')
    vars = vars or {}

    local cmfile = readfile(file)
    local targets = {}
    if cmfile then 
        for _, line in pairs(cmfile) do
            -- print('    line', line)
            if line:find(p_add_executable) then
                insertifmatch(targets, line, p_add_executable)
            elseif line:find(p_add_subdirectory) then
                local sub = {line:match(p_add_subdirectory..p_varname.."%)")}
                if sub[1] then
                    -- print('varname', sub[1], sub[2])
                    local subdir = resolvevar(sub[1], vars)
                    if subdir then
                        local subtargets = findCMakeTargets(pathjoin(path, subdir), vars)
                        for _, target in ipairs(subtargets) do
                            table.insert(targets, target)
                        end
                    else
                        print('add_subdirectory with unrecognised var', sub[1]) 
                    end
                else
                    sub = line:match(p_add_subdirectory..p_name.."%)")
                    if sub then
                        -- print('name', sub)
                        local subtargets = findCMakeTargets(pathjoin(path, sub), vars)
                        for _, target in ipairs(subtargets) do
                            table.insert(targets, target)
                        end
                    else
                        print('add_subdirectory without target')
                    end
                end
            elseif line:find(p_set) then
                -- FIXME: Not adding to vars
                local name = {line:match(p_set..p_name..p_varname)}
                -- print('p_set', line)
                if name[2] then
                    -- print('varname', name[1], name[2])
                    vars[name[1]] = name[2]
                else
                    name = {line:match(p_set..p_name..p_name)}
                    if name[2] then
                        -- print('name', name[1], name[2])
                        vars[name[1]] = name[2]
                    else
                        print('set without name')
                    end
                end
            end
        end
    end

    return targets
end

function M.findCMakeExeTarget(path, vars)
    path = path or './'
    vars = vars or {}
    local targets = findCMakeTargets(path, vars)
    for i, target in ipairs(targets) do
        targets[i] = resolvevar(target, vars)
        -- print(target, targets[i])
    end
    -- return targets[0]
    return targets
end

local res = M.findCMakeExeTarget()
print(vim.inspect(res))

return M

