
Battery = peripheral.wrap("bottom")

MaxPower = Battery.getMaxEnergyStored()

term.clear()

function check()
    local lvl = Battery.getEnergyStored()

    term.clear()
    term.setCursorPos(1,1)

    local percent = (lvl / MaxPower) * 100

    term.write(string.format("Power Level: %d%%", percent))

    if percent > 90 then
        term.setCursorPos(1,2)
        term.write("Battery Almost Full")
        redstone.setOutput("left", true)
    else
        redstone.setOutput("left", false)
    end
end

while true do
    check()
    sleep(5)
end