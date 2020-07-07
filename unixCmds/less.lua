
local tArgs = { ... }

if #tArgs ~= 1 then 
    print('Usage: less file')
    return
end

function readFile(path)
    local f = io.open(path, 'r')
    if not f then
        print('File not found: ', path)
        return
    end

    local dat = f:read("*a")
    f:close()
    return dat
end

function main()
    local abs = shell.resolve(tArgs[1])
    local allData = readFile(abs)

    local length = string.len(allData)

    -- do line wrapping

    local cols, rows = term.getSize()

    rows = rows - 1

    local lines = {}

    local currIndex = 1
    while currIndex <= length do
        local slice = allData:sub(currIndex, currIndex + cols) .. "" -- apparently theres a bug with sub and find
        local index = slice:find('\n')

        if index then
            table.insert(lines, slice:sub(1,index-1))
            currIndex = currIndex + index
        else
            table.insert(lines, slice)
            currIndex = currIndex + cols
        end
    end

    local lineCount = table.getn(lines)

    local currLine = 1
    while true do
        term.clear()
        for i, v in ipairs(lines) do
            if i >= currLine and i - currLine < rows then
                term.setCursorPos(1,i - currLine + 1)
                term.write(v)
            end
        end

        if currLine == 1 then
            term.setBackgroundColor(1)
            term.setTextColor(32768)

            term.setCursorPos(1, rows + 1)
            term.write(abs)
        elseif currLine > lineCount - rows then
            term.setBackgroundColor(1)
            term.setTextColor(32768)

            term.setCursorPos(1, rows + 1)
            term.write("(END)")
        else
            term.setCursorPos(1, rows + 1)
            term.write(":")
        end


        term.setBackgroundColor(32768)
        term.setTextColor(1)

        local sEvent, param = os.pullEvent("key")
        if sEvent == "key" then
            if param == 200 then
                if currLine > 1 then currLine = currLine - 1 end
            elseif param == 208 then
                if currLine <= lineCount - rows then currLine = currLine + 1 end
            elseif param == 16 then
                break -- pressed q
            end
        end
        
        
    end

    term.clear()
    term.setCursorPos(1,1)
end

main()