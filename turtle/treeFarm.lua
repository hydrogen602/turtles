-- util

local function assert(condition)
    if not condition then
        error('Assertian failure')
    end
end

local function assertEquals(actual, expected)
    if actual ~= expected then
        error("expected "..expected.." but got "..actual)
    end
end

-- TurtlePlus

--[[
require 'apis.turtlePlus'
local turtlePlus = {
    getBlockName=getBlockName,
    searchAndSelect=searchAndSelect,
    RelativeDir=RelativeDir
}
--]]

os.loadAPI('turtlePlus')

local t = TurtlePlus:new()

-- code

local function chopTree()
    if turtlePlus.getBlockName() ~= 'minecraft:log' then
        error('Expected tree, but got ' .. turtlePlus.getBlockName())
    end

    assert(turtle.dig())
    t:aggresiveForward()

    assert(t.dy == 0)
    
    while getBlockNameBelow() == 'minecraft:log' do
        assert(turtle.digDown())
        assert(t:down())
    end

    assert(getBlockNameBelow() == 'minecraft:dirt')

    if turtle.detectUp() then
        turtle.digUp()
    end
    t:aggresiveUp()

    if turtlePlus.searchAndSelect('minecraft:sapling') then
        turtle.placeDown()
    end

    while t.dy < 0 do
        t:aggresiveUp()
    end
    
    while getBlockNameAbove() == 'minecraft:log' do
        assert(turtle.digUp())
        t:aggresiveUp()
    end

    while t.dy > 0 do
        t:aggresiveDown()
    end

    assert(t.dy == 0)
end

local function chopTreeLine() 
    while true do
        if turtle.detect() then
            block = getBlockName()
            if block == 'minecraft:leaves' then
                assert(turtle.dig())
                t:aggresiveForward()
            elseif block == 'minecraft:log' then
                chopTree()
            else
                -- hit wall
                break
            end
        else
            t:aggresiveForward()
        end
    end
end

local function chopAll()
    while true do
        local first = true
        while not turtle.detectDown() or first do
            if turtle.detect() then
                break
            end
            first = false
            t:aggresiveForward()
        end
        t:turnLeft()
        chopTreeLine()
        t:turnRight()
        first = true
        while not turtle.detectDown() or first do
            if turtle.detect() then
                break
            end
            first = false
            t:aggresiveForward()
        end
        t:turnRight()
        chopTreeLine()
        t:turnLeft()
    end

    -- facing other wall
    t:faceDir(turtlePlus.RelativeDir.REVERSE)

    while t.dx > 0 do
        t:aggresiveForward()
    end

    assert(t.dx == 0)

    if t.dz > 0 then
        t:faceDir(turtlePlus.RelativeDir.LEFT)
    elseif t.dz < 0 then
        t:faceDir(turtlePlus.RelativeDir.RIGHT)
    else
        t:faceOriginal()
        return -- at target
    end
    
    while t.dz ~= 0 do
        t:aggresiveForward()
    end

    if t.dz == 0 and t.dx == 0 and t.dy == 0 then
        t:faceOriginal()
    else
        error("should be home, but is not")
    end
end


local before = turtle.getFuelLevel()
chopAll()
local after = turtle.getFuelLevel()

print('Consumed '..(after-before)..' fuel')
