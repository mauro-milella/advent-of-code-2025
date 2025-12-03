package.path = package.path .. ";../?.lua"

local string = require("string")
local utils = require("utils")

---See the same function in `solution1.lua`;
---this works with a buffer of any dimension
---@param n string
---@param x integer -- number of characters to consider
local function highest_number(n, x)
    local l = #n

    local buffer = {}

    -- consider the last x characters
    for i = l, l-(x-1), -1 do
        table.insert(buffer, 1, n:sub(i,i))
    end

    -- for each new character (the x-1th, x-2th, etc.),
    -- replace the xth one if is convenient;
    -- if you do that, repeat all the process towards the right.
    for i = l-x, 1, -1 do
        local c = n:sub(i,i)

        local j = 1
        local flag = false
        local update_value = nil

        while true do
            if buffer[j+1] == nil then
                if update_value ~= nil then
                    buffer[j] = update_value
                end
                
                break
            end

            if update_value ~= nil then
                c = update_value
            end

            if c >= buffer[j] then
                if buffer[j+1] <= buffer[j] then
                    update_value = buffer[j]
                else
                    flag = true
                end

                buffer[j] = c
            else
                flag = true
            end

            if flag then
                break
            end

            j = j + 1
        end
    end
    
    return tonumber(table.concat(buffer, "", 1, x))
end

local ans = 0

utils.parse_file("input.txt", function(s)
    for line in s:gmatch("[^\n]+") do
        ans = ans + highest_number(line, 12)
    end
end)

print(ans)
