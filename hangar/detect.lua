
local sensor = peripheral.wrap('top')

local function getPlayers()
    local playerTargets = {}
    local index = 1
    for name, obj in pairs(sensor.getTargets()) do
        if obj.IsPlayer then
            playerTargets[index] = name
            index = index + 1
        end
    end
    return playerTargets
end

local function inBounds(name)
    local data = sensor.getTargetDetails(name)
    if data == nil then
        error('Name '..name..' not found')
    end
    local pos = data.Position

    return pos.X > 1 and pos.X < 8 and pos.Z > -3 and pos.Z < 3 and pos.Y > -10 and pos.Y < 10
end

local p = getPlayers()
for _, name in pairs(p) do
    if name == 'Hydrogen10' then
        redstone.setOutput('bottom', inBounds(name))
    elseif name == 'billybobthegreat' or name == 'rct45011' or name == 'SirFalconLord' then
    else
        -- enemy
        local f = io.open('.dat', "a")
        f:write(name..' here, day='..os.day()..' hour='..os.time()..'\n')
        f:close()

        f = io.open('.details', 'w')
        f:write(sensor.getTargetDetails(name))
        f:close()
    end
end
