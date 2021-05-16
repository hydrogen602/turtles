-- program for requiring authentication

local pullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw -- prevent terminate

local function unixtime()
    -- returns real-time seconds
    return os.day() * 1200 + os.time() * 50
end

local settings = {
    failed=0,
    lockedUntil=0,
    passwd="admin"
}

function settings:save()
    local s = textutils.serialize({
        failed=self.failed,
        lockedUntil=self.lockedUntil,
        passwd=self.passwd
    })
    local f = io.open('/.passwd', 'w')
    f:write(s)
    f:close()
end

function settings:load()
    local function helper() 
        if fs.exists('/.passwd') then
            local f = io.open('/.passwd')
            local s = f:read('*a')
            f:close()
            local tab = textutils.unserialize(s)
            if tab.failed == nil or tab.lockedUntil == nil or tab.passwd == nil then
                error('invalid settings')
            end
            settings.failed = tab.failed
            settings.lockedUntil = tab.lockedUntil
            settings.passwd = tab.passwd
        else
            error("Couldn't find settings")
        end
    end

    local success, err = pcall(helper)
    if not success then
        print(err)
    end
end

term.clear()
term.setCursorPos(1,1)

settings:load()

print('Authentication')
while true do
    if settings.lockedUntil > unixtime() then
        term.clear()
        term.setCursorPos(1,1)
        local timeleft = settings.lockedUntil - unixtime()
        print('Locked because of '..settings.failed..' failed password attempts for another '..(math.ceil(timeleft/60))..' min')
        sleep(60)
        term.clear()
        term.setCursorPos(1,1)
    else
        write('Password: ')
        local input = read("*")
        if input ~= settings.passwd then
            print('Incorrect password')
            settings.failed = settings.failed + 1
            if settings.failed >= 3 then
                -- 3 fails = 5 min
                -- 4 fails = 7 min
                local timeLockedMin = 2*(settings.failed-3) + 5
                settings.lockedUntil = unixtime() + 60 * timeLockedMin
                print(settings.failed.." failed password attempts, locking for "..timeLockedMin.." min")
                sleep(5)
            end
            settings:save()
        else
            print('Successfully authenticated')
            settings.failed = 0
            settings:save()
            break
        end
    end
end

os.pullEvent = pullEvent

