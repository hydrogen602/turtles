local width = 51
local height = 19

--local oldPullEvent = os.pullEvent
--os.pullEvent = os.pullEventRaw

function draw()
-- frame
term.setCursorPos(3,3)
term.write('+' .. string.rep('-', width - 3 - 3) .. '+')

term.setCursorPos(3,height - 3 + 1)
term.write('+' .. string.rep('-', width - 3 - 3) .. '+')

local innerWidth = width - 6
local innerHeight = height - 6

term.setCursorPos(23, 8)
term.write('Login')

term.setCursorPos(15, 10)
term.write('Username: ')

term.setCursorPos(15, 11)
term.write('Password: ')
end