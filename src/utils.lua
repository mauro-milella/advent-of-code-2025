--[[

This file is intended to contain generic utilities which might be common 
for solving various puzzles (e.g., simply reading a file).

For an extremely overview of Lua, see:
https://learnxinyminutes.com/lua/

For a cheatseet on pattern matching, see:
https://pdfhost.io/v/YkVYUK8Om_Lua_patterns_cheatsheet

File IO and filtering:
https://www.lua.org/pil/21.1.html
https://www.luadocs.com/docs/functions/string/gsub
--]]

M = {}

---Opens read and process a file, if possible.
---@param filename string   -- the file to be read
---@param parser function   -- strategy with which the file content must be processed
---@return string|nil       -- returns the processed file content
function M.parse_file(filename, parser)
    local file, err = io.open(filename, "r")

    if not file then
        io.write("Error: ", err)
        return
    end

    local file_content = file:read("*a")

    file:close()

    return parser(file_content)
end

return M
