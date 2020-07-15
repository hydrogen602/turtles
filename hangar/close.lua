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

function closeLeftWing()
    removeBottom(colors.lightBlue)
end

function closeRightWing()
    removeBottom(colors.lime)
end

function closeNearAndFarSide()
    pulseTop(colors.green)
    pulseTop(colors.lightBlue)
    sleep(2.2)
    pulseTop(colors.green)
    pulseTop(colors.lightBlue)
end

function pushFarSideOut()
    for i = 1, 7 do
        pulseTop(colors.white)
        sleep(1)
    end
end

closeRightWing()
closeLeftWing()
pushFarSideOut()
closeNearAndFarSide()


