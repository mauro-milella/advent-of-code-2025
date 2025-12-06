package.path = package.path .. ";../?.lua"

local utils = require("utils")

local ans = 0

local input = {
    problems = {},
    operations = {}
}

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do    

        local i = 1
        for n in line:gmatch("%d+") do
            -- trick to transform (possibly) nil values into tables
            input.problems[i] = input.problems[i] or {}
            table.insert(input.problems[i], tonumber(n))
            i = i + 1
        end

        for c in line:gmatch("[%+%*]+") do
            table.insert(input.operations, c)
        end
    end
end)

function apply(a, b, c)
    if c == "*" then
        return a * b
    elseif c == "+" then
        return a + b
    else
        return nil
    end
end

---Aggregate all the values in t, leveraging c
---@param t table
---@param c string
local function solve(t, c)
    local ans = t[1]

    for i = 2, #t do
        ans = apply(ans, t[i], c)
    end

    return ans
end

-- main logic
for i = 1, #input.problems do
    ans = ans + solve(input.problems[i], input.operations[i])    
end

print(ans)

