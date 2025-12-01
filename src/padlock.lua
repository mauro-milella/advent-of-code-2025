-- Implementation of the lock needed in the first problem (and maybe some future one?)
-- See day1/solution2 for an example of usage

local rotate_with_rounds
local rotate_left
local rotate_right

local Padlock = {}

Padlock.__index = Padlock

function Padlock.new(value, rounds)
    return setmetatable({value=value or 50, rounds = rounds or 0}, Padlock)
end

---Delegate the update of a `Padlock` to `rotate_with_rounds`.
---@param padlock table
---@param action table -- [1] is a direction ("L" or "R"), while [2] is an integer
---@return table
function Padlock.__add(padlock, action)
    local direction = action[1]
    local ticks = action[2]

    local new_val, new_rounds = rotate_with_rounds(padlock.value, direction, ticks)
    
    return Padlock.new(new_val, padlock.rounds + new_rounds)
end

---Rotate the `Padlock`, but also count how many times the tick 0 is considered (the `rounds`)
---@param val integer -- the current value of the padlock
---@param direction string -- "R"ight or "L"eft direction
---@param ticks integer -- the number of ticks that are moved along a certain direction
---@return integer -- the updated value of the padlock
---@return integer -- the updated value of the rounds of the padlock
rotate_with_rounds = function (val, direction, ticks)
    local already_zero = ((val==0) and 1) or 0

    -- the number of full rounds
    local rounds = 0

    -- idempotent rounds
    if ticks >= 100 then
        rounds = rounds + ticks // 100
        ticks = math.fmod(ticks, 100)
    end

    -- rotate
    local new_val, new_rounds
    if direction == "R" then
        new_val, new_rounds = rotate_right(val, ticks)
    else
        new_val, new_rounds = rotate_left(val, ticks, already_zero)
    end

    return new_val, rounds + new_rounds
end

-- Internal logic of `rotate_with_rounds` for rotating right
rotate_right = function (val, ticks)
    local rounds = 0 
    
    val = val + ticks

    -- pacman effect (and one round is tracked)
    if val > 99 then
        val = val - 100
        rounds = 1
    end

    return val, rounds
end

-- Internal logic of `rotate_with_rounds` for rotating left
rotate_left = function (val, ticks, already_zero)
    local rounds = 0
    
    val = val - ticks

    -- we are exactly ending at zero and,
    -- in the next round, the flag
    -- "already_zero" will notice this
    if val == 0 then
        rounds = 1
    end

    -- we are triggering the pacman effect;
    -- it might be the case that we are coming
    -- from a scenario in which val was already zero
    if val < 0 then
        val = 100 + val
        rounds = rounds + 1 - already_zero
    end

    return val, rounds
end

return {
    Padlock = Padlock,
    new = Padlock.new
}