
local tArgs = { ... }

if #tArgs < 1 then 
    print('Stdin cat mode not enabled')
    return
end

function readFile(path)
    local f = io.open(path, 'r')
    if not f then
        print('File not found: ', path)
        return
    end

    io.write(f:read("*a"))
    f:close()
end

for i,v in ipairs(tArgs) do
    readFile(shell.resolve(v))
end
