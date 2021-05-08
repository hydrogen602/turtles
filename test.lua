

m = peripheral.wrap("top")

function draw()
    m.clear()
    m.setBackgroundColor(colors.black)
    m.setTextColor(colors.white)
    m.setCursorPos(1,2)
    m.write("-------")
    m.setCursorPos(1,4)
    m.write("-------")

    m.setCursorPos(2,3)
    m.write('|')
    m.setCursorPos(4,3)
    m.write('|')
    m.setCursorPos(6,3)
    m.write('|')
end

function writePointRed(char, x, y)
    m.setCursorPos(x,y)
    m.setTextColor(colors.red)
    m.write(char)
end


while true do
    draw()
    local wires = redstone.getBundledInput("back")
    if colors.test(wires, colors.white) then
        writePointRed('X', 2,3)
    end
    if colors.test(wires, colors.orange) then
        writePointRed('X', 4,3)
    end
    if colors.test(wires, colors.magenta) then
        writePointRed('X', 6,3)
    end
end

