
local f = io.open('state.txt', 'r')
local state = f:read("*a")
f:close()

local bottomColor = 0

function addBottom(color)
    bottomColor = colors.combine(bottomColor, color)
    redstone.setBundledOutput('bottom', bottomColor)
end

function openLeftWing()
    addBottom(colors.lightBlue)
end

function openRightWing()
    addBottom(colors.lime)
end

if state:find('open') then
    openLeftWing()
    openRightWing()
end