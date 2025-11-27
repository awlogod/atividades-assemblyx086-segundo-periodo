.MODEL small
.STACK 100h
.DATA
    msg1 DB 'Digite um numero de 1 a 9: $'
    ast  DB '*$'
.CODE
MAIN PROC
    ; inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; mostra mensagem
    MOV AH,09h
    LEA DX, msg1
    INT 21h

    ; lê caractere
    MOV AH,01h
    INT 21h

    ; converte ASCII -> número
    SUB AL, '0'

    ; verifica se < 1
    CMP AL, 1
    JL FORA

    ; verifica se > 9
    CMP AL, 9
    JG FORA

    ; repete AL vezes
    MOV CL, AL
    MOV CH, 0        ; CX = AL

LOOP_ASTERISCO:
    MOV AH,09h
    LEA DX, ast
    INT 21h
    LOOP LOOP_ASTERISCO

    JMP FIM

FORA:
    ; caso inválido, poderia exibir msg de erro
    ; mas aqui só sai

FIM:
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
