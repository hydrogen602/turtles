local tArgs = { ... }

if #tArgs < 1 or #tArgs > 2 then 
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

local f = io.open(tArgs[2], 'w')
if f == nil then
    print('Could not open file')
    return
end

f:write(text)
f:close()