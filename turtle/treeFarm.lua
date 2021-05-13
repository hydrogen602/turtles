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
    RelativeDir=RelativeDir,
    TurtlePlus=TurtlePlus,
    Chest=Chest
}
--]]

os.loadAPI('turtlePlus')

local t = turtlePlus.TurtlePlus:new()

-- code

local function chopTree()
    if turtlePlus.getBlockName() ~= 'minecraft:log' then
        error('Expected tree, but got ' .. turtlePlus.getBlockName())
    end

    assert(turtle.dig())
    t:aggresiveForward()

    assert(t.dy == 0)
    
    while turtlePlus.getBlockNameBelow() == 'minecraft:log' do
        assert(turtle.digDown())
        t:aggresiveDown()
    end

    assert(turtlePlus.getBlockNameBelow() == 'minecraft:dirt')

    if turtle.detectUp() then
        turtle.digUp()
    end
    t:aggresiveUp()

    if turtlePlus.searchAndSelect('minecraft:sapling') then
        if turtle.getItemCount() > 1 then -- dont place the last one
            turtle.placeDown()
        end
    end

    while t.dy < 0 do
        t:aggresiveUp()
    end
    
    while turtlePlus.getBlockNameAbove() == 'minecraft:log' do
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
            block = turtlePlus.getBlockName()
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
    local done = false
    while true do
        local first = true
        while not turtle.detectDown() or first do
            if turtle.detect() then
                done = true
                break
            end
            first = false
            t:aggresiveForward()
        end
        if done then
            break
        end
        t:turnLeft()
        chopTreeLine()
        t:turnRight()
        first = true
        while not turtle.detectDown() or first do
            if turtle.detect() then
                done = true
                break
            end
            first = false
            t:aggresiveForward()
        end
        if done then
            break
        end
        t:turnRight()
        chopTreeLine()
        t:turnLeft()
    end

    -- facing other wall
    print('Going home')
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

if turtle.getFuelLevel() < 300 then
    error('Add more fuel')
end

local before = turtle.getFuelLevel()
chopAll()
local after = turtle.getFuelLevel()

print('Consumed '..(before-after)..' fuel')

t:faceDir(turtlePlus.RelativeDir.REVERSE)
local foundLogs = false
for i=1,16 do
    local data = turtle.getItemDetail(i)
    if data ~= nil then
        if data['name'] == 'minecraft:log' and not foundLogs then
            foundLogs = true
        else
            turtle.select(i)
            turtle.drop()
        end
    end
end

local chest = turtlePlus.Chest('front')

local suckedLogsFromChest = false
while turtle.getFuelLevel() < 300 do
    if turtlePlus.searchAndSelect('minecraft:planks') then
        turtle.refuel()
    elseif turtlePlus.searchAndSelect('minecraft:log') then
        turtle.craft(1)
    else
        if suckedLogsFromChest then
            print('cant refuel')
            break
        else
            chest:getStack('minecraft:log')
            suckedLogsFromChest = true
        end
    end
end

for i=1,16 do
    local data = turtle.getItemDetail(i)
    if data ~= nil then
        turtle.select(i)
        turtle.drop()
    end
end

chest:getStack('minecraft:sapling')

t:faceOriginal()
