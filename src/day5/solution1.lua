package.path = package.path .. ";../?.lua"

local utils = require("utils")

local ans = 0

-- pairs [l,r] of fresh items
local ranges = {}

---Solve one query of the problem
---@param ranges table -- the list of fresh item ranges
---@param query table -- the item to look for
local function solve(ranges, query)

end

utils.parse_file("input.txt", function(s)
    for l, r in s:gmatch("(%d+)%-(%d+)\n") do
        table.insert(ranges, {l,r})
    end

    for n in s:gmatch("%d\n") do
        ans = ans + solve(ranges, n)
    end
end)

print(ans)
