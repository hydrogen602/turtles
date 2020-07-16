
-- term.getSize() is 51, 19 on std computers

--[[
   
 1 
 2 
 3      +-------------------
 4      | 1 
 5      | 2 
 6      | 3 
 7      | 4 
 8      | 5     
 9      | 6         Login
10      | 7     Username: _______
11      | 8     Password: _______
12      | 9 
13      |10 
14      |11 
15      |12 
16      |13 
17      +-------------------
18 
19 
--]]

term.clear()

local width = 51
local height = 19

local oldPullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

function draw()
    -- frame
    term.setCursorPos(3,3)
    term.write('+' .. string.rep('-', width - 3 - 3) .. '+')

    term.setCursorPos(3,height - 3 + 1)
    term.write('+' .. string.rep('-', width - 3 - 3) .. '+')

    for i = 4, height-3 do
        term.setCursorPos(3, i)
        term.write('|')
        term.setCursorPos(width-2, i)
        term.write('|')
    end

    local innerWidth = width - 6
    local innerHeight = height - 6

    term.setCursorPos(23, 8)
    term.write('Login')
    
    term.setCursorPos(15, 10)
    term.write('Username:')

    term.setCursorPos(15, 11)
    term.write('Password:')
end

function openDoor()
    term.clear()
    term.setCursorPos(1,1)
    redstone.setOutput('left', true)
    sleep(3)
    redstone.setOutput('left', false)
end

function main()
    draw()

    term.setCursorPos(15 + ('Username: '):len(), 10)
    local user = io.read()
    term.setCursorPos(15 + ('Password: '):len(), 11)
    local pass = io.read()

    term.clear()

    if user == 'admin' and pass == '26953547' then
        return true
    end

    if user == 'Hydrogen10' and pass == 'windowsSucks' then
        openDoor()
    elseif user == 'rct45011' and pass == 'smoothTable' then
        openDoor()
    end
    

    return false
end


while true do
    local noError, stopRunning = pcall(main)
    if stopRunning then
        os.pullEvent = oldPullEvent
        break
    end
end

term.setCursorPos(1,1)