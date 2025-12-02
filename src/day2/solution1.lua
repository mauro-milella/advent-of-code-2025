package.path = package.path .. ";../?.lua"

local string = require("string")
local utils = require("utils")

local input = {
    lbounds = {},
    rbounds = {}
}

local ans = 0

utils.parse_file("input.txt", function(s)
    for pair in s:gmatch("[^,]+") do
        local l, r = pair:match("(%d+)%-(%d+)")
        table.insert(input.lbounds, l)
        table.insert(input.rbounds, r)
    end
end)

---Check whether n is even and palindrome (it can be splitted into 2 identical parts)
---@param n string
---@return integer -- 1 if the string palindrome, 0 otherwise
function check(n)
    if #n % 2 == 1 then
        return 0
    end

    local len = #n
    local half_index = len//2
    local first_half = string.sub(n, 1, half_index)
    local second_half = string.sub(n, half_index+1, len)

    return (first_half == second_half) and 1 or 0
end

-- naive solution
for i = 1, #input.lbounds do

    local lbound = tonumber(input.lbounds[i])
    local rbound = tonumber(input.rbounds[i])

    for j = lbound, rbound, 1 do
        ans = ans + ((check(tostring(j)) == 1) and j or 0)
    end
end

print(ans)