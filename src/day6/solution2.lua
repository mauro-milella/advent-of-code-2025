package.path = package.path .. ";../?.lua"

local utils = require("utils")

local ans = 0

local input = {
    problems = {},
    operations = {}
}

-- maximum number of ciphers for the ith problem
local ciphers = {}

utils.parse_file("input.txt", function(s)
    -- use the space between the operators to find how 
    -- large is the current slot that needs to be parsed
    local i = 1
    while true do
        i = string.find(s, "[%+%*]+", i+1)

        if i == nil then
            break
        end

        table.insert(input.operations, s:sub(i,i))
        table.insert(ciphers, i)
    end

    -- previously, we found the positions of each "*" and "+";
    -- now we compute the range lengths
    for j = 1, (#ciphers-1) do
        ciphers[j] = ciphers[j+1] - ciphers[j] - 1
    end
    ciphers[#ciphers] = 3

    -- at this point, the content of each line can be manually tokenized
    -- TODO
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
