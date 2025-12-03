package.path = package.path .. ";../?.lua"

local string = require("string")
local utils = require("utils")

---Get the highest 2-digits number that is "hidden" within n;
---for example, in 81129, the highest number is "89"
---@param n string
local function highest_number(n)
    local l = #n
    
    -- iterate each character in n
    local highest_digit = n:sub(l-1,l-1)
    local lowest_digit = n:sub(l,l)

    for i = l-2, 1, -1 do
        local c = n:sub(i,i)

        if c >= highest_digit then
            if lowest_digit < highest_digit then
                lowest_digit = highest_digit
            end
            highest_digit = c
        end
    end

    return tonumber(highest_digit .. lowest_digit)
end

local ans = 0

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        ans = ans + highest_number(line)
    end
end)

print(ans)
