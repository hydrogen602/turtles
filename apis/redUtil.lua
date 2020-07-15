-- spin speed: 2.2 sec
-- linear speed: 1 sec

local colorSettings = {}

function add(side, color)
    if not colorSettings[side] then colorSettings[side] = 0 end

    colorSettings[side] = colors.combine(colorSettings[side], color)
    redstone.setBundledOutput(side, colorSettings[side])
end

function remove(side, color)
    if not colorSettings[side] then colorSettings[side] = 0 end

    colorSettings[side] = colors.subtract(colorSettings[side], color)
    redstone.setBundledOutput('side', colorSettings[side])
end

function pulse(side, color)
    add(side, color)
    sleep(0.1)
    remove(side, color)
end
