local chest = peripheral.wrap('back')

local typeName = "tile_thermalexpansion_machine_smelter_name"

local smelter = nil
for i, v in ipairs(peripheral.getNames()) do
  if peripheral.getType(v) == typeName then
    smelter = peripheral.wrap(v)
  end
end

if smelter == nil then
  error('Induction Smelter not found')
end

if chest == nil then
  error('Chest not found')
end

function detectAndMove()
  local max = chest.getInventorySize()
  for i=1,max do
    local stack = chest.getStackInSlot(i)
    if stack ~= nil and stack.name == 'Dust' then
      --print(stack.display_name, " ", stack.qty)       
      local moveAmount = stack.qty
      if moveAmount % 2 == 1 then
        moveAmount = moveAmount - 1
      end
      
      if moveAmount > 0 then
        print("Moving ", moveAmount, " ", stack.display_name)
        
        chest.pushItemIntoSlot('NORTH', i, moveAmount, 2)
        return
      end
    end
  end
end

function isSmelterReady()
  -- working on nothing rn, so next item
  --print(smelter)
  --print(smelter.getStackInSlot)
  return smelter.getStackInSlot(2) == nil
end

while true do
  if isSmelterReady() then
    detectAndMove()
  end
  sleep(5)
end
