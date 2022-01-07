
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
        for slot, item in ipairs(items) do
            if not all_items[item.name] then
                local display_name = peripheral.call(dev, 'getItemDetail', slot).displayName
                all_items[item.name] = {count = 0, name = display_name}
            end
            all_items[item.name].count = all_items[item.name].count + item.count
        end
    end
    return all_items
end


local function padRight(s, length)
    return s .. string.rep(' ', length - #s)
end


local devices = getAllStorages()
local stuff = getAllItems(devices)

local SPACING = 16
for _, item in pairs(stuff) do
    print(padRight(item.name, SPACING), item.count)
end

