-- spin speed: 2.2 sec
-- linear speed: 1 sec

local topColor = 0
local bottomColor = 0

function addTop(color)
    topColor = colors.combine(topColor, color)
    redstone.setBundledOutput('top', topColor)
end

function removeTop(color)
    topColor = colors.subtract(topColor, color)
    redstone.setBundledOutput('top', topColor)
end

function addBottom(color)
    bottomColor = colors.combine(bottomColor, color)
    redstone.setBundledOutput('bottom', bottomColor)
end

function removeBottom(color)
    bottomColor = colors.subtract(bottomColor, color)
    redstone.setBundledOutput('bottom', bottomColor)
end

function pulseTop(color)
    addTop(color)
    sleep(0.1)
    removeTop(color)
end

function pulseBottom(color)
    addBottom(color)
    sleep(0.1)
    removeBottom(color)
end

function openLeftWing()
    addBottom(colors.lightBlue)
end

function openRightWing()
    addBottom(colors.lime)
end

function openNearAndFarSide()
    pulseBottom(colors.blue)
    pulseTop(colors.lime)
    sleep(2.2)
    pulseBottom(colors.blue)
    pulseTop(colors.lime)
end

function pullFarSideIn()
    for i = 1, 7 do
        pulseTop(colors.blue)
        sleep(1)
    end
end

openLeftWing()
openNearAndFarSide()
pullFarSideIn()
openRightWing()
