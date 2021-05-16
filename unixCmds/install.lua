
-- run inside /disk

function main()
    if not fs.isDir('/bin') then
        fs.makeDir('/bin')
        print('Created /bin')
    end

    if not fs.isDir('bin') then
        print('Error: Can not find bin/ in disk')
        return
    end

    local src = shell.resolve('bin')

    local files = fs.list(src)

    local counter = 0

    for i,v in ipairs(files) do
        fs.copy(src .. '/' .. v, '/bin/' .. v)
        print('Copied bin/' .. v)
        counter = counter + 1
    end

    local setPathExists = false
    -- if fs.exists('/startup') then
    --     local f = io.open('/startup')
    --     local data = f:read()
    --     f:close()
    --     for s in data:gmatch("[^\r\n]+") do
    --         if data:find('shell[.]setPath[(]shell[.]path[(][)] [.][.] ":/bin"[)]') ~= nil then
    --             setPathExists = true
    --             break
    --         end
    --     end
    -- end

    for s in shell.path():gmatch("[^:]+") do
        if s == '/bin' then
            setPathExists = true
            break
        end
    end
    
    if setPathExists then
        print("Found /bin in path, not editing /startup")
    else
        print("/bin not in path, appending /startup")
        local f = io.open('/startup', 'a')

        if not f then 
            print('Could not open file /startup')
        end

        f:write('\n')
        f:write('shell.setPath(shell.path() .. ":/bin")\n')

        f:close()
    end

    print('Done, installed ', counter, ' files')

    print('Rebooting in 3 seconds...')
    sleep(3)
    os.reboot()
end

main()