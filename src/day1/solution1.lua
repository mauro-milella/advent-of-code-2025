-- This solution is quick and dirty;
-- for a more detailed solution, see solution2 and ../padlock

package.path = package.path .. ";../?.lua"

local utils = require("utils")

local input = {
    directions = {},
    values = {}
}

-- `parse_file` both reads the content of a file and parses it with a closure callback
utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        local rot, val = line:match("(%L)(%d+)")
        table.insert(input.directions, rot)
        table.insert(input.values, tonumber(val))
    end
end)

local lock_value = 50

local function rotate(val, direction, ticks)
    if ticks >= 100 then
        ticks = math.fmod(ticks, 100)
    end

    if direction == "R" then
        return math.fmod(val + ticks, 100)
    else
        val = val - ticks
        if val < 0 then
            val = 100 + val
        end

        return val
    end
end

local ans = 0

for i = 1, #input.directions do
    lock_value = rotate(lock_value, input.directions[i], input.values[i])

    if lock_value == 0 then
        ans = ans + 1
    end
end

print(ans)