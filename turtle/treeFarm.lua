-- util

local function assert(condition)
    if not condition then
        error('Assertian failure')
    end
end

local function searchAndSelect(name)
    for i=1,16 do
        local data = turtle.getItemDetail()
        if data ~= nil and data['name'] == name then
            turtle.select(i)
            return true
        end
    end
    return false
end

-- movement util

local function aggresiveForward()
    local tries = 0
    while tries < 100 do
        if turtle.forward() then 
            break
        end
        turtle.attack()
        sleep(0.6)
    end
    error("Error: can't move forward.")
end

local function getBlockNameAbove()
    local isBlock, data = turtle.inspectUp()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

local function getBlockNameBelow()
    local isBlock, data = turtle.inspectDown()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

local function getBlockName()
    local isBlock, data = turtle.inspect()
    if isBlock then
        return data['name']
    else
        return nil
    end
end

local function chopTree()
    local isBlock, data = turtle.inspect()
    if not isBlock then
        error(data)
    elseif data['name'] ~= 'minecraft:log' then
        error('Expected tree, but got ' .. data['name'])
    end

    assert(turtle.dig())
    aggresiveForward()

    local dy = 0
    
    while getBlockNameBelow() == 'minecraft:log' do
        assert(turtle.digDown())
        assert(turtle.down())
        dy = dy - 1
    end

    assert(getBlockNameBelow() == 'minecraft:dirt')

    if turtle.detectUp() then
        turtle.digUp()
    end
    assert(turtle.up())
    if searchAndSelect('minecraft:sapling') then
        turtle.placeDown()
    end

    while dy < 0 do
        assert(turtle.up())
        dy = dy + 1
    end    
    
    while getBlockNameAbove() == 'minecraft:log' do
        assert(turtle.digUp())
        assert(turtle.up())
        dy = dy + 1
    end

    while dy > 0 do
        assert(turtle.down())
        dy = dy - 1
    end

    assert(dy == 0)
end

local function chopTreeLine() 
    while true do
        if turtle.detect() then
            block = getBlockName()
            if block == 'minecraft:leaves' then
                assert(turtle.dig())
                aggresiveForward()
            elseif block == 'minecraft:log' then
                chopTree()
            else
                -- hit wall
                break
            end
        else
            aggresiveForward()
        end
    end
end

local function chopAll()
    while true do
        while not turtle.detectDown() do
            if turtle.detect() then break end
            aggresiveForward()
        end
        turtle.turnLeft()
        chopTreeLine()
        turtle.turnRight()
        while not turtle.detectDown() do
            if turtle.detect() then break end
            aggresiveForward()
        end
        turtle.turnRight()
        chopTreeLine()
        turtle.turnLeft()
    end

    -- facing other wall
    turtle.turnRight()
    turtle.turnRight()

    while not turtle.detect() do
        aggresiveForward()
    end

    if getBlockName() == 'minecraft:chest' then
        return
    end

    turtle.turnLeft()
    if turtle.detect() then
        turtle.turnRight()
        turtle.turnRight()
    end

    while not turtle.detect() do
        aggresiveForward()
    end

    turtle.turnLeft()
    if getBlockName() == 'minecraft:chest' then
        return
    end
    turtle.turnRight()
    turtle.turnRight()
    if getBlockName() == 'minecraft:chest' then
        return
    end

    error("Can't find home base")
end


local before = turtle.getFuelLevel()
chopAll()
local after = turtle.getFuelLevel()

print('Consumed '..(after-before)..' fuel')
