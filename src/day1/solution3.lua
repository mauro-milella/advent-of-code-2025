-- Idea for refactoring the (dirty) solution:
-- I could work with metatables and overload the _add behavior

package.path = package.path .. ";../?.lua"

local utils = require("utils")

local lock = require("lock").new(50, 0)

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        local direction, ticks = line:match("(%L)(%d+)")
        lock = lock + {direction, tonumber(ticks)}
    end
end)

print(lock.rounds)