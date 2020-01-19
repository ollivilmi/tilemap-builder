local tilemath = {}

tilemath.snap = function(size, ...)
    newValues = {...}

    for i, value in ipairs(newValues) do
        newValues[i] = value - math.fmod(value, size)
    end
    return unpack(newValues)
end

return tilemath