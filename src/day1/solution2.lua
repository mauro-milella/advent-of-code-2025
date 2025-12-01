-- Idea for refactoring the (dirty) solution:
-- I could work with metatables and overload the _add behavior

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

-- rotate the lock, but also count how many times
-- having a number of ticks >= 100 caused to 
-- overpass the value zero
local function rotate_with_rounds(val, direction, ticks)
    -- todo: see how to do ternary operator
    local already_zero = 0
    if val == 0 then
        already_zero = 1
    end

    -- the number of full rounds
    local rounds = 0

    -- idempotent rounds
    if ticks >= 100 then
        rounds = rounds + ticks // 100
        ticks = math.fmod(ticks, 100)
    end

    -- right direction
    if direction == "R" then
        val = val + ticks

        -- overpassing 99 is another way
        -- for saying overpassing zero
        if val > 99 then
            val = val - 100
            rounds = rounds + 1
        end
    
    else
        val = val - ticks

        -- we are exactly ending at zero and,
        -- in the next round, the flag
        -- "already_zero" will notice this
        if val == 0 then
            rounds = rounds + 1
        end

        if val < 0 then
            val = 100 + val
            rounds = rounds + 1 - already_zero
        end
    end

    return val, rounds
end

local ans = 0
local rounds = 0

for i = 1, #input.directions do
    lock_value, rounds = rotate_with_rounds(lock_value, input.directions[i], input.values[i])
    ans = ans + rounds
end

print(ans)