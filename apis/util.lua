
function toHumanReadableStr(n, unitStr)
    if not unitStr then unitStr = '' end

    if n / 1000.0 < 1 then return string.format('%d%s', n, unitStr) else n = n / 1000 end
    if n / 1000.0 < 1 then return string.format('%dK%s', n, unitStr) else n = n / 1000 end
    if n / 1000.0 < 1 then return string.format('%dM%s', n, unitStr) else n = n / 1000 end
    if n / 1000.0 < 1 then return string.format('%dG%s', n, unitStr) else n = n / 1000 end
    if n / 1000.0 < 1 then return string.format('%dT%s', n, unitStr) else n = n / 1000 end
    return string.format('%dP%s', n, unitStr)
end

function findPeripherialsWithName(name)
    local ls = peripheral.getNames()
    local found = {}

    for i, side in ipairs(ls) do
        if string.find(side, name) ~= nil then table.insert(found, side) end
    end

    return found
end

function findPeripherialsWithType(typeName)
    local ls = peripheral.getNames()
    local found = {}

    for i, side in ipairs(ls) do
        if peripheral.getType(side) == typeName then table.insert(found, side) end
    end

    return found
end
