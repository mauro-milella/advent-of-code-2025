package.path = package.path .. ";../?.lua"

local utils = require("utils")

local beams = {}

local ans = 0

-- `parse_file` both reads the content of a file and parses it with a closure callback
utils.parse_file("input.txt", function(s)
    local line_length = s:find("\n")
    for i = 1, line_length do
        beams[i] = false
    end
    beams[line_length//2] = true

    local i = 1
    for line in s:gmatch("[^\n]+") do

        -- encode the next line of beams
        local buffer = {}

        -- iterate through all the S and ^ in the line
        local pos = line:find("[S%^]")

        while pos ~= nil do

            -- the current position takes a beam
            if beams[pos] == true then
                beams[pos] = false
                ans = ans + 1
            end

            table.insert(buffer, pos-1)
            table.insert(buffer, pos+1)

            pos = line:find("[S%^]", pos+1)
        end

        for _, p  in pairs(buffer) do
            beams[p] = true
        end

        i = i + 1
    end
end)

print(ans)