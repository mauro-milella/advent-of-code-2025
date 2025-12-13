package.path = package.path .. ";../?.lua"

local utils = require("utils")

------Breadth-first search of the space of all the possibly combinations;
---@param target number -- the exact number we want to reproduce, starting from all the lights off (0)
---@param schematics table -- table of bitmasks, representing the switch off/on (xor) operations
---@return integer -- the (minimum) depth at which target is reached
local function bfs(target, schematics)
    -- [1]: current state, [2] depth
    local queue = {{0,0}}

    -- use this to avoid developing the frontier of states 
    -- that are part of an infinite loop
    local visited_states = {}

    -- ~ is the xor
    while #queue > 0 do
        local popped_element = table.remove(queue, 1)
        local state, depth = table.unpack(popped_element, 1, 2)

        if visited_states[state] == true then 
            goto continue 
        else
            visited_states[state] = true
        end

        depth = depth + 1

        for _, s in pairs(schematics) do
            local new_state = state ~ s

            if (new_state ~ target) == 0 then return depth end

            table.insert(queue, {new_state, depth})
        end

        ::continue::
    end

    -- queue is always growing, so this should never be triggered
    return -1
end

utils.parse_file("input.txt", function(s)
    local ans = 0

    local i = 0
    for line in s:gmatch("[^\n]+") do
        local diagram = 0
        local schematics = {}
        local a, b, c = line:match("%[(.+)%] (.+) %{(.+)%}")

        -- build the diagram
        local pos = a:find("#", 1)
        while pos ~= nil do
            diagram = diagram | (1<<(pos-1))
            pos = a:find("#", pos+1)
        end

        -- each schema specification is a bitmask;
        -- in the capture (), ignore <^> the escaped <)> character
        for piece in b:gmatch("%(([^%)]+)%)") do
            local schema_value = 0
            for n in piece:gmatch("%d+") do
                schema_value = schema_value | (1<<tonumber(n))
            end

            table.insert(schematics, schema_value)
        end

        -- joltage can be ignored in the first part of the problem
        -- ...
        ans = ans + bfs(diagram, schematics)
    end

    print(ans)
end)
