--
-- Author: Jonathan Rotter
--
-- Better turtle because it remembers where it is
--

RelativeDir = {
    ORIGINAL=0,
    RIGHT=1,
    REVERSE=2,
    LEFT=3,
}

TurtlePlus = {
    dx=0,
    dy=0,
    dz=0,
    relDir=RelativeDir.ORIGINAL
}

-- Top-down view of coords
-- 
-- +x
--  ^
--  |
--  +-->+z
-- y comes out of the page
-- this (should) be right handed
-- moving forward without ever having turned is thus a +x move

function TurtlePlus:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TurtlePlus:forward()
    print('forward')
    if not turtle.forward() then
        return false -- move failed
    end

    if self.relDir == RelativeDir.ORIGINAL then
        dx = dx + 1
    elseif self.relDir == RelativeDir.REVERSE then
        dx = dx - 1
    elseif self.relDir == RelativeDir.RIGHT then
        dz = dz + 1
    elseif self.relDir == RelativeDir.LEFT then
        dz = dz - 1
    else
        error('Invalid direction: '..self.relDir)
    end
    return true
end

function TurtlePlus:back()
    print('back')
    if not turtle.back() then
        return false -- move failed
    end

    if self.relDir == RelativeDir.ORIGINAL then
        self.dx = self.dx - 1
    elseif self.relDir == RelativeDir.REVERSE then
        self.dx = self.dx + 1
    elseif self.relDir == RelativeDir.RIGHT then
        self.dz = self.dz - 1
    elseif self.relDir == RelativeDir.LEFT then
        self.dz = self.dz + 1
    else
        error('Invalid direction: '..self.relDir)
    end
    return true
end

function TurtlePlus:up()
    if not turtle.up() then
        return false
    end
    self.dy = self.dy + 1
    return true
end

function TurtlePlus:down()
    if not turtle.up() then
        return false
    end
    self.dy = self.dy - 1
    return true
end

function TurtlePlus:turn(turnNum)
    if type(turnNum) ~= "number" then
        error("TurtlePlus:turn => TypeError: Expected number but got "..type(turnNum))
    end
    -- +1 is right, +2 is turn around (right twice), +3 is right 3x (left)
    -- -1 is left, -2 is turn around (left twice)
    local reduced = turnNum % 4
    if reduced == 0 then

    elseif reduced == 1 then
        turtle.turnRight()
    elseif reduced == 2 then
        turtle.turnRight()
        turtle.turnRight()
    elseif reduced == 3 then
        turtle.turnLeft()
    else
        error("this should never happen - TurtlePlus:turn")
    end
    self.relDir = (self.relDir + reduced) % 4
end

function TurtlePlus:turnRight()
    TurtlePlus:turn(RelativeDir.RIGHT)
end

function TurtlePlus:turnLeft()
    TurtlePlus:turn(RelativeDir.LEFT)
end

function TurtlePlus:turnAround()
    TurtlePlus:turn(RelativeDir.REVERSE)
end

function TurtlePlus:faceDir(turnNum) 
    if type(turnNum) ~= "number" then
        error("TurtlePlus:faceDir => TypeError: Expected number but got "..type(turnNum))
    end
    TurtlePlus:turn(-self.relDir + turnNum)
end

function TurtlePlus:faceOriginal() 
    TurtlePlus:turn(-self.relDir)
end


setmetatable(TurtlePlus, {__call=TurtlePlus.new})