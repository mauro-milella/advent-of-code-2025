package.path = package.path .. ";../?.lua"

local string = require("string")
local utils = require("utils")

---See the same function in `solution1.lua`;
---this works with a buffer of 12 characters
---@param n string
local function highest_number(n)
    local l = #n
    
    local buffer = {}

    for i = l, l-12, -1 do
        table.insert(buffer, 1, n:sub(i,i))
    end

    for i = l-13, 1, -1 do
        local c = n:sub(i,i)

        local j = 1
        local flag = false
        local update_value = nil

        while true do
            if c >= buffer[j] then
                if buffer[j+1] < buffer[j] then
                    update_value = buffer[j]
                else
                    flag = true
                end

                buffer[j] = c
            end

            if flag then
                break
            end

            j = j + 1
        end
    end

    return tonumber(table.concat(buffer, "", 1, 12))
end

local ans = 0

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        ans = ans + highest_number(line)
    end
end)

print(ans)
