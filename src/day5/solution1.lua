package.path = package.path .. ";../?.lua"

local utils = require("utils")

local ans = 0

-- pairs [l,r] of fresh items
local ranges = {}

---Solve one query of the problem
---@param ranges table -- the list of fresh item ranges
---@param query integer -- the item to look for
local function solve(ranges, query)
    for i = 1, #ranges do
        if query >= ranges[i][1] and query <= ranges[i][2] then
            return 1
        end
    end
    
    return 0
end


utils.parse_file("input.txt", function(s)
    -- parse the first part of the file
    for l, r in s:gmatch("(%d+)%-(%d+)\n") do
        table.insert(ranges, {tonumber(l), tonumber(r)})
    end

    -- and now the second part
    local second_section_idx = s:find("\n\n")
    for query in s:sub(second_section_idx, #s):gmatch("%d+") do
        ans = ans + solve(ranges, tonumber(query))
    end
end)

print(ans)
