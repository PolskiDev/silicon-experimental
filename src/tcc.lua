--#Compile:
-- lua tcc.lua <file> -o <out>

--#Crosscompile:
-- lua tcc.lua <file> -o <out> -i <OS> <Arch>
require 'lang.paroot-environment'

os.remove(string.sub(arg[3]..".go",1,string.find(arg[3]..".go","%.")-1))
function go_build()
    if arg[5] == nil then
        os.execute("go build -o "..arg[1])
    elseif arg[5] and arg[6] then
        os.execute("env GOOS="..arg[5].." GOARCH="..arg[6].." go build -o "..arg[1])
    elseif arg[5] and arg[6] == nil then
        os.execute("env GOOS="..arg[5].." go build -o "..arg[1])
    end
end
function extern_go()
    os.remove(arg[1]..".extern")
    os.remove(arg[1]..".go")
end



local lvm = "lua"
os.execute(lvm.." lang/section_gsub.lua "..arg[1]..".global "..arg[3]..".extern")
os.execute(lvm.." lang/lexical_analyzer.lua "..arg[1].." "..arg[3]..".go")
if arg[2] == "-o" then
    go_build()
    extern_go()
    
    
elseif arg[2] == "-op" then
    go_build()
   
elseif arg[2] == "--run" then
    if getEnvironmentOS() == 'Windows' then
        os.execute("cls")
    else
        os.execute("clear")
    end
    os.execute("go run "..arg[3]..".go")
    extern_go()
end