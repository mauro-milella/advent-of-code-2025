package.path = package.path .. ";../?.lua"

local utils = require("utils")

-- pairs [l,r] of fresh items
local ranges = {}

---We want to merge all the ranges together,
---and return the number of integers covered.
---@param ranges any
---@return integer
local function solve(ranges)
    local merged_ranges = {}
    local l = #ranges

    -- sort the ranges increasingly by the left bound
    table.sort(ranges, function (a,b)
        return a[1] < b[1]
    end)

    for i = 2, l do
        local current_left, current_right = table.unpack(ranges[i], 1, 2)
        local previous_left, previous_right = table.unpack(ranges[i-1], 1, 2)

        -- if the current left bound overlaps with the right bound
        -- of the updated segment, update me;
        if current_left <= previous_right then
            ranges[i][1] = math.min(current_left, previous_left)
            ranges[i][2] = math.max(current_right, previous_right)

            -- in any case, I must force the push in a new collection
            if i == l then
                table.insert(merged_ranges, ranges[i])
            end

        -- otherwise, push the previous element in a new collection,
        -- and keep me for future updates
        else
            table.insert(merged_ranges, ranges[i-1])
        end
    end

    local ans = 0

    for i = 1, #merged_ranges do
        ans = ans + (merged_ranges[i][2] - merged_ranges[i][1]) + 1 
    end

    return ans
end


utils.parse_file("input.txt", function(s)
    -- parse the first part of the file
    for l, r in s:gmatch("(%d+)%-(%d+)\n") do
        table.insert(ranges, {tonumber(l), tonumber(r)})
    end

    print(solve(ranges))
end)