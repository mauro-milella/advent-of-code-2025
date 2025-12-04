package.path = package.path .. ";../?.lua"

local utils = require("utils")

-- https://www.lua.org/pil/11.2.html
-- the map is a matrix that defaults the return value *to itself*
-- when accessing illegal indexes
local map = setmetatable({}, {
    -- this defines the default arguments of the map
    __index = function(_, key)
        -- when an invalid index is provided (e.g., [-1][3][9999][-4])
        -- the same `map` table is returned!
        return setmetatable({}, map)
    end
})

local nrows = 0
local ncols = 0
local ans = 0

-- `parse_file` both reads the content of a file and parses it with a closure callback
utils.parse_file("input.txt", function(s)
    local i = 1

    for line in s:gmatch("[^\n]+") do
        map[i] = {}
        
        for j = 1, #line do
           map[i][j] = line:sub(j,j)
        end

        ncols = #line
        i = i + 1
    end

    nrows = i-1
end)

--- Return 1 if the current cell is "living", that is, it has fewer than x neighbors.
---@param map table
---@param row integer
---@param col integer
---@param x integer -- a cell is alive if #neighbors < x
function living_cell(map, row, col, x, neighbor_char)
    if map[row][col] ~= neighbor_char then
        return false
    end

    local c = 0

    for i = -1, 1 do
        for j = -1, 1 do
            if not(i == 0 and j == 0) then
                c = c + ((map[row+i][col+j] == neighbor_char) and 1 or 0)
            end
        end
    end

    return (c < x)
end


for i = 1, nrows do
    for j = 1, ncols do
        ans = ans + ((living_cell(map, i, j, 4, '@')) and 1 or 0)
    end
end

print(ans)
