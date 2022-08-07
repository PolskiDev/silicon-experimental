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

function __filename(file)
    return file:match("^.+/(.+)$")
end


t = {}
line = read_file(arg[1]..".cr")


--local regex = '\"([^\"\\]*(?:\\.[^\"\\]*)*)\"|\'([^\'\\]*(?:\\.[^\'\\]*)*)\'|[^%s]+'
--local regex = "((?!\'[%w%s]*[\\']*[%w%s]*).(?![%w%s]*[\\']*[%w%s]*\'))"
--local regex = "((?<![\\])[\'\"])((?:.(?!(?<![\\])\1))*.?)\1"
--local regex = [[((?<![\\])['"])((?:.(?!(?<![\\])\1))*.?)]]
--local regex = "[^%s\"\']+|\"([^\"]*)\"|\'([^\']*)'"
--local regex = '%s+(?=(?:(?:[^\"]*\"){2})*[^\"]*\"[^\"]*$)'
--local regex = '([^%s]+).*([^\"]).*([\"$])'
--local regex = "[^%s]+[a-z$]"
local regex = '([^\"]*)'
local regex = "[^%s]+"
--local regex = '[^%s"\']+|"([^"]*)"|\'([^\']*)\''
--local regex = '[^"]|["$]'
--local regex = '(?:[^\"](?=(?:[^\"]*?(?:[\"][^\"]*?[\"][^\"]*?)+$)|(?:[^\"]*?$)))*|(^[^\"]*[\"][^\"]*$)'
--local regex = '\"[^\"]+\"|([^\"]+)'
--local regex = '(?-s)(\"%S+)%h(?=.*?\")'
--local regex = '(?<!\")\"(?!% )([^"\r]+)\"(?!\")(*SKIP)(*F)|(?<!\")\"% ([^\"\r]+)\"(?!\")'
local QT_COUNT = false

for token in string.gmatch(line, regex) do
    table.insert(t, token)
    --print(token)
    if string.gmatch(token,'"') then
        print "Encontrei aspas no token"
        if QT_COUNT == false then
            QT_COUNT = true
        end
        if QT_COUNT == true then
            QT_COUNT = false
            table.concat(t," ")
        end
        

    end
    print(inspect(t))
end




-- Analisar tokens
for i=1,#t do
    -- Inicio e fim do programa
    if t[i] == BEGIN_PROGRAM then
        print "\n\nInicio do programa\n"
        --LINKER = read_file(arg[1]..".global",'w')
        COMPILER = io.open(arg[2], "w")
        COMPILER:write("package main\n")
        --COMPILER:write("import \"fmt\"\n")

        
    elseif t[i] == END_PROGRAM then
        print "Fim do programa\n"
        COMPILER:flush()
        COMPILER:close()

    -- Incluir modulos externos
    elseif t[i] == IMPORT_MODULE then
        local mod = read_file(t[i+1])
        print ("Incluindo módulo: "..t[i+1].."\n")
        COMPILER:write(mod.."\n\n\n")
        --COMPILER:write(LINKER)

    elseif t[i] == IMPORT_EXTERN_VARFILE then
        local mod = read_file(t[i+1]..".extern")
        print ("Incluindo módulo: "..mod.."\n")
        COMPILER:write(mod.."\n\n\n")
        --COMPILER:write(LINKER)

    elseif t[i] == USE_MODULE then
        print ("Usando módulo nativo: "..t[i+1])
        COMPILER:write("import \""..t[i+1].."\"\n\n")

    -- Métodos e Variáveis
    elseif string.match(t[i], KEYWORD_FUNC) then   
        if string.match(t[i+1], KEYWORD_MAIN) then
            print "Detectado método principal"
            COMPILER:write("func main")
        else
            print "Detectou metodo"
            COMPILER:write("func "..t[i+1])
        end
        print("Nome do metodo: "..t[i+1])
        print("Tipo do metodo: "..t[i-1].."\n")

        if t[i+2] == ":" then
            -- For C Purposes
            t[i+3] = t[i+3]:gsub(KEYWORD_INT, KEYWORD_BANCKEND_INT)
            t[i+3] = t[i+3]:gsub(KEYWORD_FLOAT, KEYWORD_BANCKEND_FLOAT)
            t[i+3] = t[i+3]:gsub(KEYWORD_BOOL, KEYWORD_BANCKEND_BOOL)
            t[i+3] = t[i+3]:gsub(KEYWORD_STRING, KEYWORD_BANCKEND_STRING)

            -- For (type):(value) notation
            t[i+3] = t[i+3]:gsub(":", " ")


            print("Parâmetros: "..t[i+3])

            t[i-1] = t[i-1]:gsub(KEYWORD_INT, KEYWORD_BANCKEND_INT)
            t[i-1] = t[i-1]:gsub(KEYWORD_FLOAT, KEYWORD_BANCKEND_FLOAT)
            t[i-1] = t[i-1]:gsub(KEYWORD_BOOL, KEYWORD_BANCKEND_BOOL)
            t[i-1] = t[i-1]:gsub(KEYWORD_STRING, KEYWORD_BANCKEND_STRING)
            --t[i-1] = t[i-1]:gsub(KEYWORD_VOID, "")


            if t[i-1] == KEYWORD_VOID then
                COMPILER:write(t[i+3])
            else
                COMPILER:write(t[i+3].." "..t[i-1])
            end 
            
        end

    elseif t[i] == OPEN_COMMENT then
        print("Detectado abertura de comentário")
        COMPILER:write("/*")

    elseif t[i] == CLOSE_COMMENT then
        print("Detectado fechamento de comentário")
        COMPILER:write("*/")

    elseif t[i] == KEYWORD_RETURN then
        print("Retornando valor: "..t[i+1])
        COMPILER:write("return "..t[i+1]..";")

    elseif t[i] == KEYWORD_CALL then
        print("Chamada a funcao: "..t[i+1])

        if t[i+2] == ":" then
            print("Parâmetros invocados: "..t[i+3])
            COMPILER:write(t[i+1]..t[i+3]..";\n")
        else
            print("Sem parâmetros a invocar!")
            COMPILER:write(t[i+1].."();\n")
        end

    elseif t[i] == KEYWORD_REASSIGN then
        print("Atribuição de valor em variavel")
        local var_name = t[i+1]
        local var_value = t[i+3]
        COMPILER:write(var_name..t[i+2]..var_value.."\n")

        
    elseif t[i] == KEYWORD_VAR then
        t[i+3] = t[i+3]:gsub(KEYWORD_FRONTEND_CONCAT, KEYWORD_BACKEND_CONCAT)

        print "Declaração de variável"
        print("Identificador da variável: "..t[i+1])
        print("Sinal de atribuição: "..t[i+2])

        if t[i-1] == KEYWORD_INT then t[i-1] = KEYWORD_BANCKEND_INT end
        if t[i-1] == KEYWORD_FLOAT then t[i-1] = KEYWORD_BANCKEND_FLOAT end
        if t[i-1] == KEYWORD_STRING then t[i-1] = KEYWORD_BANCKEND_STRING end
        if t[i-1] == KEYWORD_BOOL then t[i-1] = KEYWORD_BANCKEND_BOOL end

        print("Tipo da variável: "..t[i-1])
        print("Conteúdo da variável: "..t[i+3].."\n")

        ----------------------------------------------

        if t[i+3] == KEYWORD_VOID then
            if t[i-1] == KEYWORD_BANCKEND_STRING then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_STRING.."\n")
    
            elseif t[i-1] == KEYWORD_BANCKEND_INT then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_INT.."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_FLOAT then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_FLOAT.."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_BOOL then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_BOOL.."\n")

            end
        else
            if t[i-1] == KEYWORD_BANCKEND_STRING then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_STRING.." "..t[i+2].." "..t[i+3].."\n")
    
            elseif t[i-1] == KEYWORD_BANCKEND_INT then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_INT.." "..t[i+2].." "..t[i+3].."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_FLOAT then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_FLOAT.." "..t[i+2].." "..t[i+3].."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_BOOL then
                COMPILER:write("var "..t[i+1].." "..KEYWORD_BANCKEND_BOOL.." "..t[i+2].." "..t[i+3].."\n")

            end
        end

    elseif t[i] == KEYWORD_CONST then
        t[i+3] = t[i+3]:gsub(KEYWORD_FRONTEND_CONCAT, KEYWORD_BACKEND_CONCAT)

        print "Declaração de constante"
        print("Identificador da constante: "..t[i+1])
        print("Sinal de atribuição: "..t[i+2])

        if t[i-1] == KEYWORD_INT then t[i-1] = KEYWORD_BANCKEND_INT end
        if t[i-1] == KEYWORD_FLOAT then t[i-1] = KEYWORD_BANCKEND_FLOAT end
        if t[i-1] == KEYWORD_STRING then t[i-1] = KEYWORD_BANCKEND_STRING end
        if t[i-1] == KEYWORD_BOOL then t[i-1] = KEYWORD_BANCKEND_BOOL end

        print("Tipo da constante: "..t[i-1])
        print("Conteúdo da constante: "..t[i+3].."\n")

        ----------------------------------------------

        if t[i+3] == KEYWORD_VOID then
            if t[i-1] == KEYWORD_BANCKEND_STRING then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_STRING.."\n")
    
            elseif t[i-1] == KEYWORD_BANCKEND_INT then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_INT.."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_FLOAT then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_FLOAT.."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_BOOL then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_BOOL.."\n")

            end
        else
            if t[i-1] == KEYWORD_BANCKEND_STRING then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_STRING.." "..t[i+2].." "..t[i+3].."\n")
    
            elseif t[i-1] == KEYWORD_BANCKEND_INT then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_INT.." "..t[i+2].." "..t[i+3].."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_FLOAT then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_FLOAT.." "..t[i+2].." "..t[i+3].."\n")

            elseif t[i-1] == KEYWORD_BANCKEND_BOOL then
                COMPILER:write("const "..t[i+1].." "..KEYWORD_BANCKEND_BOOL.." "..t[i+2].." "..t[i+3].."\n")
            end
        end

    elseif t[i] == KEYWORD_TYPECAST then
        print("Conversao de tipos")

        local primary_typeof = t[i+1]
        local primary_var = t[i+2]

        t[i+4] = t[i+4]:gsub(KEYWORD_INT,KEYWORD_BANCKEND_INT)
        t[i+4] = t[i+4]:gsub(KEYWORD_FLOAT,KEYWORD_BANCKEND_FLOAT)
        t[i+4] = t[i+4]:gsub(KEYWORD_STRING,KEYWORD_BANCKEND_STRING)
        t[i+4] = t[i+4]:gsub(KEYWORD_BOOL,KEYWORD_BANCKEND_BOOL)

        local secondary_typeof = t[i+4]
        local secondary_var = t[i+5]

        COMPILER:write(primary_var.." := "..secondary_typeof.."("..secondary_var..")\n")

    elseif t[i] == KEYWORD_VECTOR then
        print("Declaração de vetor")

        t[i+2] = t[i+2]:gsub("%(","[")
        t[i+2] = t[i+2]:gsub("%)","]")
        print("Identificador do vetor: "..t[i+1])
        print("Tamanho do vetor: "..t[i+2])
        print("Conteúdo do vetor: "..t[i+4])

        t[i-1] = t[i-1]:gsub(KEYWORD_INT,KEYWORD_BANCKEND_INT)
        t[i-1] = t[i-1]:gsub(KEYWORD_FLOAT,KEYWORD_BANCKEND_FLOAT)
        t[i-1] = t[i-1]:gsub(KEYWORD_STRING,KEYWORD_BANCKEND_STRING)
        t[i-1] = t[i-1]:gsub(KEYWORD_BOOL,KEYWORD_BANCKEND_BOOL)

        --COMPILER:write("let mut "..t[i+1].." "..t[i+3].." ["..t[i+4].."];\n")
        COMPILER:write(t[i+1].." := "..t[i+2]..t[i-1]..t[i+4].."\n")



    elseif t[i] == KEYWORD_MATRIX then
        print("Declaração de matriz")

        t[i+2] = t[i+2]:gsub("%(","[")
        t[i+2] = t[i+2]:gsub("%)","]")
        print("Identificador da matriz: "..t[i+1])
        print("Tamanho da matriz: "..t[i+2])
        print("Conteúdo da matriz: "..t[i+4])

        t[i-1] = t[i-1]:gsub(KEYWORD_INT,KEYWORD_BANCKEND_INT)
        t[i-1] = t[i-1]:gsub(KEYWORD_FLOAT,KEYWORD_BANCKEND_FLOAT)
        t[i-1] = t[i-1]:gsub(KEYWORD_STRING,KEYWORD_BANCKEND_STRING)
        t[i-1] = t[i-1]:gsub(KEYWORD_BOOL,KEYWORD_BANCKEND_BOOL)

        COMPILER:write(t[i+1].." := "..t[i+2]..t[i-1]..t[i+4].."\n") 

    -- Entrada e saída padrão
    elseif t[i] == STD_IN then
        print "Entrada padrão"
        print("Armazenado na variável: "..t[i+1].."\n")
        COMPILER:write("fmt.Scan(&"..t[i+1]")\n")


    elseif t[i] == STD_OUT then
        if string.match(t[i+1],'"') then
            print "Saída padrão\n"
            if t[i+2] then
                COMPILER:write("fmt.Printf("..t[i+1]..","..t[i+2]..")\n")
            else
                COMPILER:write("fmt.Printf("..t[i+1]..")\n")
            end
            
        else
            t[i+1] = t[i+1]:gsub(KEYWORD_FRONTEND_CONCAT, KEYWORD_BACKEND_CONCAT)

            print "Saída variável"
            print("Variável relacionada: "..t[i+1].."\n")
            if t[i+2] then
                COMPILER:write("fmt.Printf("..t[i+1]..","..t[i+2]..")\n")
            else
                COMPILER:write("fmt.Printf("..t[i+1]..")\n")
            end
        end

    elseif t[i] == STD_OUTLINE then
        if string.match(t[i+1],'"') then
            print "Saída padrão, pule uma linha\n"
            COMPILER:write("fmt.Println("..t[i+1]..")\n")
        else
            t[i+1] = t[i+1]:gsub("%.%.","+")

            print "Saída variável, pule uma linha"
            print("Variável relacionada: "..t[i+1].."\n")
            COMPILER:write("fmt.Println("..t[i+1]..")\n")
        end

    -- Tipos de valores
    elseif string.match(t[i],KEYWORD_STRING_QUOTES) then
        local found = nil
        --for k=t[i],#t do
        
       -- end

        --for j=i,#t do
        --    if string.match(t[j],'"') then
        --        print "Achou cadeia de char"
        --        break
        --    end
        --end
        ---------- TRATAR -----------------
        -----------------------------------
        --for j=i,string.find(t[j],'"') do
        --    print("Encontrado em :"..j)
        --end
        --for j in string.gmatch(t[i], "\"") do
        --    print("Encontrado em :"..j)
        --end
        ------------------------------------


        print("Detectou string: "..t[i])
        print("Texto da string: "..string.sub(t[i], 2,#t[i]-1).."\n")
        --COMPILER:write(t[i])

    elseif tonumber(t[i]) and not string.find(t[i], "%.") then
        print "Detectou inteiro.\n"
        --COMPILER:write(t[i])

    elseif tonumber(t[i]) and string.find(t[i], "%.") then
        print "Detectou ponto flutuante.\n"
        --COMPILER:write(t[i])


    -- Repeticao
    elseif t[i] == KEYWORD_WHILE then
        print "Laço detectado"
        local v1 = t[i+1]
        local v2 = t[i+3]

        local sinal = nil

        if t[i+2] == "<" then
            sinal = "<"
        elseif t[i+2] == ">" then
            sinal = ">"
        elseif t[i+2] == "<=" then
            sinal = "<="
        elseif t[i+2] == "==" then
            sinal = "=="
        elseif t[i+2] == "!=" then
            sinal = "!="
        end

        print("[ "..KEYWORD_WHILE.." "..v1.." "..sinal.." "..v2.." ]")
        print("Valor 1: "..v1)
        print("Valor 2: "..v2)
        print("Sinal: "..sinal.."\n")

        COMPILER:write("for "..v1..sinal..v2)
        COMPILER:write(v1.." += 1\n")

    elseif t[i] == KEYWORD_FOR then
        print("Iteração detectada")
        local c = t[i+1]
        local exp = t[i+2]
        local min = exp:sub(1,exp:find("%.")-1)
        local max = exp:sub(exp:find("%.")+2,#exp)

        print("Iterador: "..c)
        print("Alcance: "..min)
        print("Máximo: "..max)
        COMPILER:write("for "..c.." := "..min.."; "..c.." < "..max.."; "..c.."++")
        

    elseif t[i] == KEYWORD_INCREMENT then
        local x = t[i+1]
        print("Adicionado na variavel ["..x.."] o valor de 1 unidade")
        COMPILER:write(x.." += 1;\n")

    elseif t[i] == KEYWORD_DECREMENT then
        local x = t[i+1]
        print("Removido na variavel ["..x.."] o valor de 1 unidade")
        COMPILER:write(x.." -= 1;\n")

    --Condicionais
    elseif t[i] == KEYWORD_IF then
        print "Condicional SE detectado"
        local v1 = t[i+1]
        local v2 = t[i+3]

        local sinal

        if t[i+2] == "<" then
            sinal = "<"
        elseif t[i+2] == ">" then
            sinal = ">"
        elseif t[i+2] == "<=" then
            sinal = "<="
        elseif t[i+2] == "==" then
            sinal = "=="
        elseif t[i+2] == "!=" then
            sinal = "!="
        end

        print("[ SE "..v1.." "..sinal.." "..v2.." ]")
        print("Valor 1: "..v1)
        print("Valor 2: "..v2)
        print("Sinal de comparação: "..sinal.."\n")

        COMPILER:write("if "..v1..sinal..v2)

    elseif t[i] == KEYWORD_ELIF then
        print "Condicional SENAOSE detectado"
        local v1 = t[i+1]
        local v2 = t[i+3]

        local sinal

        if t[i+2] == "<" then
            sinal = "<"
        elseif t[i+2] == ">" then
            sinal = ">"
        elseif t[i+2] == "<=" then
            sinal = "<="
        elseif t[i+2] == "==" then
            sinal = "=="
        elseif t[i+2] == "!=" then
            sinal = "!="
        end

        print("[ SENAOSE "..v1.." "..sinal.." "..v2.." ]")
        print("Valor 1: "..v1)
        print("Valor 2: "..v2)
        print("Sinal de comparação: "..sinal.."\n")
        COMPILER:write("else if "..v1..sinal..v2)


    elseif t[i] == KEYWORD_ELSE then
        print "Condicional SENAO detectado"
        COMPILER:write("else\n")

        
    -- Blocos de código
    elseif t[i] == OPEN_BLOCK then
        print "Detectou abertura de bloco\n"
        COMPILER:write("{\n")
    
    elseif t[i] == CLOSE_BLOCK then
        print "Detectou fechamento de bloco\n"
        COMPILER:write("\n}\n")
    --else
    --    print "Ignorar: Símbolo desconhecido ou não registrado!"
    --    print "Possivelmente declaração ou armazenamento de variavel na entrada padrão.\n"
    end

end



