
ReactorPrototype = {
    react=nil,
    maxOutput=0,
    controlRodLvl=50
}

function ReactorPrototype.new(cls, side, maxOutput)
    local react = peripheral.wrap(side)
    assert(react, "No peripheral on that side")
    assert(react.getConnected(), "No reactor connected")
    assert(type(maxOutput) == 'number', 'MaxOutput must be a positive number')
    assert(maxOutput > 0, "MaxOutput must be a positive number")

    self = { 
        react=react,
        maxOutput=maxOutput,
        controlRodLvl=50
    }

    setmetatable(self, cls)
    cls.__index = cls
    return self
end

setmetatable(ReactorPrototype, {__call=ReactorPrototype.new})

function ReactorPrototype:getEfficiency() -- in RF/mB
    if self.react.getFuelConsumedLastTick() == 0 then return 0 end
    return self.react.getEnergyProducedLastTick() / self.react.getFuelConsumedLastTick()
end

function ReactorPrototype:setControlRods()
    -- does more power or less power need to be produced?

    -- local power = self.react.getEnergyProducedLastTick() -- RF/tick

    -- local percentage = (power / self.maxOutput) * 100

    -- local newControlRodLvl = 0
    -- if percentage > 110 then
    --     -- overproducing
    --     local overProducingBy = percentage - 100

    --     newControlRodLvl = math.min(100, self.controlRodLvl + overProducingBy)
    -- elseif percentage < 90 then
    --     -- underproducing
    --     local underProducingBy = 100 - percentage

    --     newControlRodLvl = math.max(0, self.controlRodLvl - underProducingBy / 2)
    -- end

    local energyPercentage = self.react.getEnergyStored() / 10000000 * 100

    self.controlRodLvl = energyPercentage

    -- if energyPercentage < 20 then
    --     self.controlRodLvl = 0
    -- elseif energyPercentage > 80 then
    --     self.controlRodLvl
    -- else
    --     self.controlRodLvl = newControlRodLvl
    -- end

    local cCount = self.react.getNumberOfControlRods()

    for i = 0, cCount - 1 do
        self.react.setControlRodLevel(i, self.controlRodLvl)
    end

    return self.controlRodLvl
end

function ReactorPrototype:getPower() -- in RF/tick
    return self.react.getEnergyProducedLastTick()
end

function ReactorPrototype:getStoredEnergy() -- in RF
    return self.react.getEnergyStored()
end

function ReactorPrototype:getOn()
    return self.react.getActive()
end

