-- run this file using, of course, `lua solution.lua` in this folder;
-- since modules are loaded (via `require`) by looking at LUA_PATH env variable, 
-- we add a reference to the parent folder, looking for any lua file.
package.path = package.path .. ";../?.lua"

-- and this is where our utilities lives
local utils = require("utils")

-- in this example, imagine we have to read two columns as in 
-- https://adventofcode.com/2024/day/1;
-- we are going to store them in this table
local input = {
    a = {},
    b = {}
}

-- `parse_file` both reads the content of a file and parses it with a closure callback
utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        local a, b = line:match("(%d+)%s+(%d+)")
        table.insert(input.a, tonumber(a))
        table.insert(input.b, tonumber(b))
    end
end)

-- this is the logic required by the problem mentioned above
table.sort(input.a)
table.sort(input.b)

local ans = 0

for i = 1, #input.a do 
    ans = ans + math.abs(input.a[i] - input.b[i])    
end

-- you can directly copy and paste the solution to the advent of code website
io.write(ans, "\n")