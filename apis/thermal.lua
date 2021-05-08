
function getBatteryDetails(sideOrPeriph)
    -- arg is either peripheral or the side its on
    -- Returns energy stored, max energy
    if type(sideOrPeriph) == 'string' then sideOrPeriph = peripheral.wrap(sideOrPeriph) end

    return sideOrPeriph.getEnergyStored(), sideOrPeriph.getMaxEnergyStored() 
end