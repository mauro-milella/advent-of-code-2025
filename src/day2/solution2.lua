package.path = package.path .. ";../?.lua"

local utils = require("utils")

local input = {
    lbounds = {},
    rbounds = {}
}

utils.parse_file("input.txt", function(s)
    for pair in s:gmatch("[^,]+") do
        local l, r = pair:match("(%d+)%-(%d+)")
        table.insert(input.lbounds, l)
        table.insert(input.rbounds, r)
    end
end)

---Check whether the given str can be transformed to an empty string,
---by substituting a certain substring (different from the whole string)
---with the empty character.
---@param str string
---@return integer -- 1 if the check is satisfied, 0 otherwise
function check(str)
    -- extract a piece of text, of at most the half of its length
    for i = 1, #str//2 do
        for j = 1, #str//2 do
            -- try to substitute every occurrence of piece with the empty character
            if #str:gsub(str:sub(i, i+j-1), "") == 0 then
                return 1
            end
        end
    end

    return 0
end

-- naive solution
local ans = 0

for i = 1, #input.lbounds do
    local lbound = tonumber(input.lbounds[i])
    local rbound = tonumber(input.rbounds[i])

    for j = lbound, rbound, 1 do
        ans = ans + ((check(tostring(j)) == 1) and j or 0)
    end
end

print(ans)
