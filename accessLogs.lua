
function getSide()
    local sides = { 'left', 'right', 'top', 'bottom', 'back', 'front' }

    for i, v in ipairs(sides) do
        if disk.hasData(v) then
            return v
        end
    end
end

Side = getSide()

Filename = 'access.log'

function main()
    if not fs.isDir('/disk') then
        print("No directory at /disk")
        return
    end

    if fs.isDir('/disk/' .. Filename) then
        print("File /disk/" .. Filename .. " is directory")
        return
    end

    if not fs.exists('/disk/' .. Filename) then
        print('Creating /disk/' .. Filename)
    end

    local f = io.open('/disk/' .. Filename, 'a')

    if not f then 
        print('Could not open file /disk/' .. Filename)
    end

    print('AccessLogger Running...')

    local isActive = false

    while true do
        if redstone.getInput('right') then
            if not isActive then
                isActive = true
                local time = textutils.formatTime(os.time(), true)
                local day = os.day()
                local report = string.format('Day=%d Time=%s :: Mining door pin entered', day, time)
                f:write(report)
                f:flush()

                print(report)
            end
        else
            if isActive then isActive = false end
        end
        sleep(2)
    end

    f:close()
end

main()
