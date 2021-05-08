
os.loadAPI('reactor')
os.loadAPI('util')

local side = ''
local r = reactor.ReactorPrototype(side, 800)

while true do
    term.clear()
    term.setCursorPos(1,1)
    term.write(string.format('Power = %s/tick', util.toHumanReadableStr(r:getPower(), 'RF')))
    term.setCursorPos(1,2)
    term.write(string.format('Efficiency = %s/mB', util.toHumanReadableStr(r:getEfficiency(), 'RF')))
    term.setCursorPos(1,3)
    term.write(string.format('Control Rod Insertion: %d%%', r.controlRodLvl))

    r:setControlRods()

    sleep(5)
end