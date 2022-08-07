-- "(.*?)"
-- "(["'])(?:(?=(\\?))\2.)*?\1"
-- "([^"]*)"
-- "[\"'](?:(?<=\")[^\"\\]*(?s:\\.[^\"\\]*)*\"|(?<=')[^'\\]*(?s:\\.[^'\\]*)*')""
-- "([^"\\]|\\.|\\\n)*"|'([^'\\]|\\.|\\\n)*'
-- ((?<![\\])['"])((?:.(?!(?<![\\])\1))*.?)\1



local inspect = require "lang.inspect"
require "lang.lexer_dict"

local open = io.open    
local function read_file(path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


t = {}
line = read_file(arg[1])


-- Analisar tokens
local MATCH_STRING = line:match(KEYWORD_STRING.." "..KEYWORD_VAR)
local MATCH_STRING_TYPEOF = MATCH_STRING:sub(0,MATCH_STRING:find(" ")-1)
local MATCH_STRING_VAR = MATCH_STRING:sub(MATCH_STRING:find(" ")+1,#MATCH_STRING)


--Variables and constants
line = line:gsub(KEYWORD_STRING.." "..KEYWORD_VAR, "var")
line = line:gsub(KEYWORD_INT.." "..KEYWORD_VAR, "var")
line = line:gsub(KEYWORD_FLOAT.." "..KEYWORD_VAR, "var")
line = line:gsub(KEYWORD_BOOL.." "..KEYWORD_VAR, "var")
line = line:gsub(KEYWORD_VOID.." "..KEYWORD_VAR, "var")

line = line:gsub(KEYWORD_STRING.." "..KEYWORD_CONST, "const")
line = line:gsub(KEYWORD_INT.." "..KEYWORD_CONST, "const")
line = line:gsub(KEYWORD_FLOAT.." "..KEYWORD_CONST, "const")
line = line:gsub(KEYWORD_BOOL.." "..KEYWORD_CONST, "const")
line = line:gsub(KEYWORD_VOID.." "..KEYWORD_CONST, "const")

--Undefined value for variables
line = line:gsub(": "..KEYWORD_STRING, " "..KEYWORD_BANCKEND_STRING)
line = line:gsub(": "..KEYWORD_INT, " "..KEYWORD_BANCKEND_INT)
line = line:gsub(": "..KEYWORD_FLOAT, " "..KEYWORD_BANCKEND_FLOAT)
line = line:gsub(": "..KEYWORD_BOOL, " "..KEYWORD_BANCKEND_BOOL)

--Assigning values to variables
line = line:gsub(KEYWORD_REASSIGN, "")



--Concatenation
line = line:gsub(" %.%. ", " + ")

--Write parsed file
local result = io.open(arg[2],'w')
result:write(line)
result:flush()
result:close()
