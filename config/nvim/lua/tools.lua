local api = vim.api
local cmd = vim.api.nvim_command

local M = {}

function string:ltrim()
    return self:gsub('^%s*', '')
end

-- TODO: search up to find root with .git/
-- TODO; Parse CMakeLists.txt for set, add_executable and add_subdirectory
-- TODO: replace target variables with variable values

local function readfile(path, skipcomments)
    if skipcomments == nil then skipcomments = true end
    local fp = io.open(path, 'r')
    if fp ~= nil then
        local lines = {}
        local line = fp:read('*l')
        while line ~= nil do
            line = line:ltrim()
            if skipcomments then
                if #line > 0 and line:sub(1,1) ~= '#' then
                    table.insert(lines, line)
                end
            else
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

local function findInLines(lines, find)
    find = find or 'add_executable%('
    local res = {}
    for _, line in pairs(lines) do
        if line:find(find) then
            table.insert(res, line)
        end
    end
    return res
end

local function targetName(line)
    local name = line:match([[add_executable%(%s*(%${%w+})]])
    if name then
        print('Target was variable', name)
        -- TODO: lookup variable name
    else
        name = line:match('add_executable%(%s*(%w+)')
    end
    return name
end

local function findCMakeTargets(file)
    file = file or 'CMakeLists.txt'

    local cmfile = readfile(file)
    local targets = {}
    if cmfile ~= nil then 
        local exelines = findInLines(cmfile)
        for _, line in pairs(exelines) do
            local name = targetName(line)
            table.insert(targets, name)
        end
        local subdirlines = findInLines(cmfile, 'add_subdirectory%(')
        for _, line in pairs(subdirlines) do
            local dir = line:match('add_subdirectory%(%s*(%w+)%s*%)')
            local path = dir:gsub('/?$', '') .. '/CMakeLists.txt'
            for _, name in pairs(findCMakeTargets(path)) do
                table.insert(targets, dir .. '/' .. name)
            end
        end
    end

    return targets
end

function M.findCMakeExeTarget()
    local targets = findCMakeTargets()
    return targets
end

local res = M.findCMakeExeTarget()

print(vim.inspect(M.findCMakeExeTarget()))

return M

