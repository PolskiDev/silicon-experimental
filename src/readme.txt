[COMENTÁRIOS]:
    /* Meu comentário */


[INICIO E FIM DO PROGRAMA]:
    programa
        ....

    fimprograma


[ESTRUTURA BÁSICA DE UM PROGRAMA]:
    programa
        vazio funcao principal : () {
                ...
        }

    fimprograma



[INCLUIR ARQUIVO DE VARIAVEIS GLOBAIS]:
    @externo <arquivo>

    *Para (main.global) em (main.cr):
        @externo main



[IMPORTAR MÓDULOS]:
@incluir <arquivo>

*Inclui o arquivo (modulo.h) com código escrito em Go 
dentro do arquivo (*.cr) onde foi mencionado.

    @incluir modulo.h




[IMPORTAR BIBLIOTECAS GO]:
@importar <biblioteca>

*Importa a biblioteca Go descrita dentro de um arquivo (*.cr)

    @importar fmt




[TIPOS PRIMITIVOS]:
    inteiro
    flutuante
    cadeia
    logico
    verdadeiro
    falso
    vazio


[DECLARAR VARIÁVEIS E CONSTANTES]:
**As variaveis devem ser declaradas no arquivo <file>.global,
isso é, se o arquivo de código-fonte se chama (main.cr),
devem ser declaradas as variaveis no arquivo (main.global).


    <tipo> variavel <nome> = <valor>
    <tipo> constante <nome> = <valor>

    inteiro variavel n1 = 15
    inteiro constante n1 = 15

    flutuante variavel f1 = 34.5
    flutuante constante f1 = 34.5

    cadeia variavel str1 = "Hello world"
    cadeia constante str1 = "Hello world"

    logico variavel b1 = verdadeiro
    logico constante b1 = verdadeiro


    [VARIAVEIS NÃO INICIALIZADAS]:
    *Declarando variaveis com valor inicial vazio/nulo.
    
        vazio variavel <nome>: <tipo>

        vazio variavel nome: cadeia
        vazio variavel idade: inteiro
        vazio variavel salario: flutuante



    [ATRIBUIR/REATRIBUIR VALORES]:
        atribuir <nome> = <valor>


        atribuir nome = "Gabriel"
        atribuir idade = 21
        atribuir salario = 1300.24

        atribuir gama[3] = 127
        atribuir gama[0] = 15


[TYPECAST] - *Ainda em desenvolvimento:
    conversao <tipo_resultado> <nome_resultado> = <tipo> <variavel>


[WHILE LOOP]:
    enquanto a < 10 {
        ...
    }



[ITERAÇÃO]:
    para i 1..10 {
        ...
    }


[IF-ELSEIF-ELSE]:
    se a == 13 {
        ...
    } senaose a > 13 {
        ...
    } senao {
        ...
    }

[SAÍDA DE DADOS]:
    escreva <variavel>
    escreval <variavel>


    [MESMA LINHA]:
        cadeia variavel msg = "Hello world"
        escreva msg

    [MESMA LINHA FORMATADO]:
        cadeia variavel word = "A palavra eh %s %s"
        escreva word,"Julia","Alves"


    [PULA UMA LINHA]:
        cadeia variavel msg = "Hello world"
        escreval msg

    [PULA UMA LINHA FORMATADO]:
        cadeia variavel word = "A palavra eh %s %s\n"
        escreva word,"Julia","Alves"



[ENTRADA DE DADOS]
    leia <variavel>

    leia x



[ENTRADA E SAÍDA DE DADOS]
    leia x
    escreval x
    



[CONCATENAR VARIAVEIS]:
    cadeia variavel str3 = str1 .. str2


[CONCATENAR VARIAVEIS EM SAÍDA PADRÃO]:
    escreval str1..str2


[VETORES/ARRAYS]:
    inteiro vetor gama () = {0,1,440}
    inteiro vetor gama (3) = {0,1,440}


[MATRIZES]:   *Ainda em desenvolvimento
    inteiro matriz eta (3)(4)(2) = [0,1,0],[3,1,9,6],[2,9]



[DECLARAR MÉTODO]
    <tipo> funcao <nome> : (<nome>:<tipo>,<nome>:<tipo>, ...) {
                ...
    }

    inteiro funcao calcular : (a:inteiro,b:inteiro) {
                ...
    }



[DECLARAR FUNÇÃO]
    <tipo> funcao <nome> : (<nome>:<tipo>,<nome>:<tipo>, ...) {
                ...
        retorne <valor>
    }

    inteiro funcao calcular : (a:inteiro,b:inteiro) {
        retorne a+b
    }



[CHAMAR FUNÇÃO OU MÉTODO]
    chamar calcular : ()
    chamar somar : (3,4)



[INCREMENTO (+1)]
    inteiro variavel x = 0
    inc x


[DECREMENTO (-1)]
    inteiro variavel x = 15
    dec x



Gabriel Margarido
