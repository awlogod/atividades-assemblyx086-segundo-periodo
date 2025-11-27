TITLE Imprime_Alfabeto
.MODEL SMALL
.STACK 100h
.DATA
    NOVA_LINHA DB 10,13,'$'  ; Caractere nova linha

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX
    
    ; Começa com 'A' (ASCII 65)
    MOV DL, 65
    
MAIUSCULAS:
    ; Imprime letra maiúscula
    MOV AH, 2
    INT 21h
    
    ; Próxima letra
    INC DL
    
    ; Compara se chegou em 'Z'+1 (91)
    CMP DL, 91
    JNZ MAIUSCULAS
    
    ; Pula linha
    MOV AH, 9
    LEA DX, NOVA_LINHA
    INT 21h
    
    ; Começa com 'a' (ASCII 97)
    MOV DL, 97
    
MINUSCULAS:
    ; Imprime letra minúscula
    MOV AH, 2
    INT 21h
    
    ; Próxima letra
    INC DL
    
    ; Compara se chegou em 'z'+1 (123)
    CMP DL, 123
    JNZ MINUSCULAS
    
    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN