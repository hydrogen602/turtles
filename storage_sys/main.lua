
local INPUT = "left"
local OUTPUT = "right"

function getAllStorages()
    local devices = peripheral.getNames()
    local storage_devices = {}
    for i, dev in ipairs(devices) do
        if dev ~= INPUT and dev ~= OUTPUT then
            for i, m in ipairs(peripheral.getMethods(dev)) do
                -- check if device is chest-like
                if m == "pushItems" then
                    table.insert(storage_devices, dev)
                    break
                end
            end
        end
    end
    return storage_devices
end


function getAllItems(storage_devices)
    local all_items = {}
    for i, dev in ipairs(storage_devices) do
        local items = peripheral.call(dev, 'list')
        for slot, item in pairs(items) do
            if not all_items[item.name] then
                local display_name = peripheral.call(dev, 'getItemDetail', slot).displayName
                all_items[item.name] = {count = 0, name = display_name}
            end
            all_items[item.name].count = all_items[item.name].count + item.count
        end
    end

    table.sort(all_items, function (a, b)
        return a.name < b.name
    end)

    return all_items
end


local function padRight(s, length)
    return s .. string.rep(' ', length - #s)
end


local devices = getAllStorages()
local stuff = getAllItems(devices)

local SPACING = 32

local scroll = 0
while true do
    term.clear()
    term.setCursorPos(1,1)
    local w, h = term.getSize()

    local counter = scroll
    for _, item in pairs(stuff) do
        if counter < -h + 2 then
            break
        end
        if counter <= 0 then
            print(padRight(item.name, SPACING), item.count)
        end
        counter = counter - 1
    end

    local ev, info, _, _ = os.pullEvent()
    if ev == "mouse_scroll" then
        scroll = scroll + info
        if scroll < 0 then
            scroll = 0
        end
    elseif ev == "key" then
        if info == keys.up then
            scroll = scroll - 1
            if scroll < 0 then 
                scroll = 0
            end
        elseif info == keys.down then
            scroll = scroll + 1
        else
            break
        end
    end
        
end

