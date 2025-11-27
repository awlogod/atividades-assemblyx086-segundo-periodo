; filepath: /Users/dede/Documents/Faculdade/assembly/lab05_01.asm
TITLE Imprime_Asteriscos
.MODEL SMALL
.STACK 100h
.DATA
    CONTADOR DW 50   ; Contador para 50 asteriscos
    ASTERISCO DB '*$'
    NOVA_LINHA DB 10,13,'$'  ; Caracteres para nova linha

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; Imprime 50 asteriscos na horizontal
    MOV CX, CONTADOR    ; CX = contador do loop
LOOP_HORIZONTAL:
    MOV AH, 2          ; Função para imprimir caractere
    MOV DL, '*'        ; Caractere a ser impresso
    INT 21h
    LOOP LOOP_HORIZONTAL ; Decrementa CX e continua se não zero

    ; Pula linha
    MOV AH, 9
    LEA DX, NOVA_LINHA
    INT 21h

    ; Imprime 50 asteriscos na vertical
    MOV CX, CONTADOR
LOOP_VERTICAL:
    MOV AH, 2          ; Imprime asterisco
    MOV DL, '*'
    INT 21h
    
    MOV AH, 9          ; Pula linha
    LEA DX, NOVA_LINHA
    INT 21h
    
    LOOP LOOP_VERTICAL  ; Decrementa CX e continua se não zero

    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN