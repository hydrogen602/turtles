
local PAUSE = 10 -- in sec
local DATA_POINTS = 100
local CHEST_SIDE = "right"

local data = {}
local counter = 1
local chest = peripheral.wrap(CHEST_SIDE)
if not chest then
    error("No Chest found with given peripheral name")
end

local function getItemCount()
    local count = 0
    for i, v in pairs(chest.list()) do
        count = count + v.count
    end
    return count
end

local last = 0

while true do
    term.clear()
    term.setCursorPos(1,1)

    local curr = getItemCount()
    local rate = (curr - last) / PAUSE
    last = curr

    data[counter] = rate

    local sum = 0
    local points = 0
    for i,v in pairs(data) do
        sum = sum + v
        points = points + 1
    end
    print("Rate in items/sec =", sum / points)

    os.sleep(PAUSE)
    counter = counter + 1
    if counter > DATA_POINTS then
        counter = 1
    end
end