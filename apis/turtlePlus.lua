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

setmetatable(TurtlePlus, {__call=TurtlePlus.new})

function TurtlePlus:forward()
    if not turtle.forward() then
        return false -- move failed
    end

    if self.relDir == RelativeDir.ORIGINAL then
        self.dx = self.dx + 1
    elseif self.relDir == RelativeDir.REVERSE then
        self.dx = self.dx - 1
    elseif self.relDir == RelativeDir.RIGHT then
        self.dz = self.dz + 1
    elseif self.relDir == RelativeDir.LEFT then
        self.dz = self.dz - 1
    else
        error('Invalid direction: '..self.relDir)
    end
    return true
end

function TurtlePlus:aggresiveForward()
    local tries = 0
    while tries < 20 and not turtle.detect() do
        if self:forward() then
            return
        end
        turtle.attack()
        sleep(0.6)
        tries = tries + 1
    end
    error("Error: can't move forward.")
end

function TurtlePlus:back()
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

function TurtlePlus:aggresiveUp()
    local tries = 0
    while tries < 20 and not turtle.detectUp() do
        if self:up() then
            return
        end
        turtle.attackUp()
        sleep(0.6)
        tries = tries + 1
    end
    error("Error: can't move up.")
end

function TurtlePlus:down()
    if not turtle.down() then
        return false
    end
    self.dy = self.dy - 1
    return true
end

function TurtlePlus:aggresiveDown()
    local tries = 0
    while tries < 20 and not turtle.detectDown() do
        if self:down() then
            return
        end
        turtle.attackDown()
        sleep(0.6)
        tries = tries + 1
    end
    error("Error: can't move down.")
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
    self:turn(RelativeDir.RIGHT)
end

function TurtlePlus:turnLeft()
    self:turn(RelativeDir.LEFT)
end

function TurtlePlus:turnAround()
    self:turn(RelativeDir.REVERSE)
end

function TurtlePlus:faceDir(turnNum) 
    if type(turnNum) ~= "number" then
        error("TurtlePlus:faceDir => TypeError: Expected number but got "..type(turnNum))
    end
    self:turn(-self.relDir + turnNum)
end

function TurtlePlus:faceOriginal() 
    self:turn(-self.relDir)
end

-- Move forward while funcCondition(TurtlePlus) evaluates to true and there is no block in the way
-- attacks mobs in the way
function TurtlePlus:forwardWhile(funcCondition)
    if type(funcCondition) ~= "function" then
        error("TurtlePlus:forwardWhile => TypeError: Expected function but got "..type(funcCondition))
    end

    local function condition()
        local result = funcCondition(self)
        if type(result) ~= "boolean" then 
            error("TurtlePlus:forwardWhile => TypeError: Expected function to return boolean but got "..type(result))
        end
        return result
    end

    while condition() do
        self:aggresiveForward()
    end
end


-- non-movement stuff

function getBlockNameAbove()
    local isBlock, data = turtle.inspectUp()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

function getBlockNameBelow()
    local isBlock, data = turtle.inspectDown()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

function getBlockName()
    local isBlock, data = turtle.inspect()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

function searchAndSelect(name)
    for i=1,16 do
        local data = turtle.getItemDetail(i)
        if data ~= nil and data['name'] == name then
            turtle.select(i)
            return true
        end
    end
    return false
end