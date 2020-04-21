-- automatically fill scripts variable with userscripts.

local function load_script(url, scripts, reload)
    local a = scripts
    local b = scripts
    local last_word = ""
    local first = true
    for word in string.gmatch(url, '([^.]+)') do
        if not first then
            b = a
            last_word = word
            if not a[word] then
                a[word] = {}
            end
            a = a[word]
        end
        first = false
    end
    if reload then
        package.loaded[url] = url
    end
    b[last_word] = require(url)
end

local function recursiveEnumerate(folder, fileTree, first, scripts, reload)

    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(folder)
    for i, v in ipairs(filesTable) do
        local file = folder .. "/" .. v
        if lfs.isFile(file) and not first then
            fileTree = fileTree .. "\n" .. string.gsub(string.gsub(file, "/", "."), ".lua", "")
            load_script(string.gsub(string.gsub(file, "/", "."), ".lua", ""), scripts, reload)
        elseif lfs.isDirectory(file) then
            fileTree = recursiveEnumerate(file, fileTree, false, scripts, reload)
        end
    end
    return fileTree
end

return function(basePath)
    local scripts = {}
    scripts.reloadAll = function()
        recursiveEnumerate(basePath, "", true, scripts, true)
    end
    recursiveEnumerate(basePath, "", true, scripts, false)
    return scripts
end
