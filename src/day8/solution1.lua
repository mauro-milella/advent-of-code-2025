package.path = package.path .. ";../?.lua"

local utils = require("utils")

-- input of the problem
local coordinates = {}

-- if groups[i] == i, then groups[i] is the "leader" of its group;
-- otherwise, groups[i] contains a reference that, if followed,
-- eventually leads to the first case.
-- In other words, this is a non-optimal disjoint set implementation.
local groups = {}

-- the cardinality of each group
local sizes = {}

-- all the possible distances
local distances = {}

-- `parse_file` both reads the content of a file and parses it with a closure callback
utils.parse_file("input.txt", function(s)
    local i = 1

    for line in s:gmatch("[^\n]+") do
        local x, y, z = line:match("(%d+),(%d+),(%d+)") 
        table.insert(coordinates, {tonumber(x), tonumber(y), tonumber(z)})
        
        groups[i] =  i
        sizes[i] = 1

        i = i + 1
    end
end)


---Tridimensional Euclidean distance
---@param a table -- the first triplets (coordinates)
---@param b table -- similar to `a`
---@return number
local function distance(a, b)
    local _a = a[1] - b[1]
    local _b = a[2] - b[2]
    local _c = a[3] - b[3]

    return math.sqrt(_a*_a + _b*_b + _c*_c)
end

---Linear search for the leader of group `g`, starting from position `i`.
---@param i number
---@param g table
---@return number
local function group_leader(i, g)
    if g[i] == i then
        return i
    else
        return group_leader(g[i], g)
    end
end

for i = 1, #coordinates do
    for j = i+1, #coordinates do
        if i ~= j then
            table.insert(distances, {i=i, j=j, d=distance(coordinates[i], coordinates[j])})
        end
    end
end

table.sort(distances, function (a,b) return a.d < b.d end)

for i = 1, 1000 do
    local p = distances[i]

    local leader_i = group_leader(p.i, groups)
    local leader_j = group_leader(p.j, groups)
    
    if leader_i ~= leader_j then
        if sizes[leader_i] < sizes[leader_j] then
            leader_i, leader_j = leader_j, leader_i
        end

        sizes[leader_i] = sizes[leader_i] + sizes[leader_j]
        sizes[leader_j] = 0
        
        groups[leader_j] = leader_i
    end
end

table.sort(sizes, function (a,b) return a > b end)

print(sizes[1] * sizes[2] * sizes[3])