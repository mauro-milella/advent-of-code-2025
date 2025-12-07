package.path = package.path .. ";../?.lua"

local utils = require("utils")

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

---Collect all the ciphers, column-wise, in the given matrix of characters;
---the columns are the ones between l and l+r-1.
---
---For example, consider:
---5 
-- 2 
-- 58
-- 99
-- + 
---
---The resulting table, considering l=1, r=2 and h=4 is {5259, 89} (the "+" can be ignored)
---
---@param m table -- matrix of characters, including spaces and digits
---@param l integer -- left bound of the chunk to be cipherized
---@param r integer -- right bound of the chunk to be cipherized
---@param h integer -- the h of each column
---@return table -- a list of integers
local function cipherize(m, l, r, h)
    local ans = {}

    for i = 1, r-l+1 do
        local n_as_string = ""
        for j = 1, h do
            n_as_string = n_as_string .. m[j][l+i-1]
        end

        table.insert(ans, tonumber(n_as_string))
    end

    return ans
end

print("README!")
print("1) Remember to change 'the height of your problem' in the 'cipherize' function")
print("\t(e.g., it is 3 for the toy example)")
print("2) Beware to check your personal input when copy-pasting it;")
print("\tthe assumption, here, is that every line ends with a space character.\n")

-- main logic
-- variables for keeping track of the bounds within
-- a certain problem is defined
local l_bound, r_bound = 1, ciphers[1]

local ans = 0

for i = 1, #ciphers do
    local n = cipherize(input.matrix, l_bound, r_bound, 4)

    ans = ans + solve(n, input.operations[i])
    
    -- skip to the next problem section, if the latter is well defined
    l_bound = r_bound + 2
    if ciphers[i+1] == nil then break end
    r_bound = l_bound + ciphers[i+1] - 1
end

print(ans)
