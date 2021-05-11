require 'apis.turtlePlus'

turtle = {}
function turtle.forward() return true end
function turtle.back() return true end
function turtle.turnLeft() return true end
function turtle.turnRight() return true end

local function assert(condition)
    if not condition then
        error('Assertian failure')
    end
end


local t = TurtlePlus()
t:forward()

assert(t.dx == 1)
assert(t.dz == 0)
assert(t.relDir == RelativeDir.ORIGINAL)

t:turnRight()
t:forward()
t:turnAround()
t:back()

assert(t.relDir == RelativeDir.LEFT)
assert(t.dx == 1 and t.dz == 2)

t:faceDir(RelativeDir.REVERSE)
t:forward()
t:faceDir(RelativeDir.LEFT)
t:forward()
t:forward()
t:faceOriginal()

assert(t.dx == 0)
assert(t.dz == 0)
assert(t.relDir == RelativeDir.ORIGINAL)