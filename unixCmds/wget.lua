local tArgs = { ... }

if #tArgs ~= 1 then 
    print('Usage: wget url')
    return
end

local fw = http.get(tArgs[1])
if fw == nil then
    print('URL not found')
    return
end

local text = fw.readAll()
fw.close()

local fileName = (tArgs[1]):gsub(".*/", "")
local f = io.open(fileName, 'w') -- tArgs[2]
if f == nil then
    print('Could not open file')
    return
end

f:write(text)
f:close()