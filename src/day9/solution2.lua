package.path = package.path .. ";../?.lua"

local utils = require("utils")

local coordinates = {}

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        local x, y = line:match("(%d+),(%d+)") 
        table.insert(coordinates, {x=tonumber(x), y=tonumber(y)})
    end
end)

---Check whether the rectangle delimited by {c1.x,c1.y} and {c2.x,c2.y}
---is included within the polygon defined by cs.
---@param c1 table
---@param c2 table
---@param cs table
local function inside_polygon(c1, c2, cs)
    for _, c in ipairs(cs) do
        
    end

    return true
end

---Compute the area of the rectangle, whose corners are `c1` and `c2`
---@param c1 table -- contains .x and .y coordinates
---@param c2 table -- similar to as above
local function area(c1, c2)
    return math.abs(c1.x - c2.x + 1) * math.abs(c1.y - c2.y + 1)
end

-- iterate all the possible N(N-1)/2 corners
local ans = 0
for i = 1, #coordinates-1 do
    for j = i+1, #coordinates do
        ans = math.max(ans, area(coordinates[i], coordinates[j]))
    end
end
