package.path = package.path .. ";../?.lua"

local utils = require("utils")

local ans = 0

local input = {
    matrix = {},
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
    for line in s:gmatch("[^\n]+") do
        local row = {}
        for c in line:gmatch(".") do
            table.insert(row, c)
        end

        table.insert(input.matrix, row)
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


local function cipherize(m, l, r, height)
    local ans = {}

    for i = 1, r-l+1 do
        local n_as_string = ""
        for j = 1, height do
            n_as_string = n_as_string .. m[j][l+i-1]
            print(i, j)
        end

        print("RES: ", n_as_string)
    end

    return ans
end

print("Remember to change 'the height of your problem' in the 'cipherize' function")
print("(e.g., it is 3 for the toy example)")

-- main logic
-- variables for keeping track of the bounds within
-- a certain problem is defined
local l_bound, r_bound = 1, ciphers[1]
for i = 1, #ciphers do
    local n = cipherize(input.matrix, l_bound, r_bound, 3)
    
    print("Problem", i)
    print(n[1])
    
    -- skip to the next problem section, if the latter is well defined
    l_bound = r_bound + 2
    if ciphers[i+1] == nil then break end
    r_bound = l_bound + ciphers[i+1] - 1
end

print(ans)
