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

local function chopTree ()
    local isBlock, data = turtle.inspect()
    if not isBlock then
        error(data)
    elseif data['name'] ~= 'minecraft:log' then
        error('Expected tree, but got ' .. data['name'])
    end

    assert(turtle.dig())
    aggresiveForward()

    local dy = 0
    while getBlockNameAbove() == 'minecraft:log' do
        assert(turtle.dig())
        assert(turtle.up())
        dy = dy + 1
    end

    while dy > 0 do
        assert(turtle.down())
        dy = dy - 1
    end

    assert(turtle.back())
    if not searchAndSelect('minecraft:sapling') then
        error("Couldn't find any saplings")
    end
    assert(turtle.place())
end