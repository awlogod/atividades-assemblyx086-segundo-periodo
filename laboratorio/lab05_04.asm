TITLE Imprime_Minusculas
.MODEL SMALL
.STACK 100h
.DATA
    NOVA_LINHA DB 10,13,'$'  ; Caractere nova linha
    CONTADOR DB 4            ; Contador para 4 letras por linha

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX
    
    ; Começa com 'a' (ASCII 97)
    MOV DL, 97       ; DL = letra atual
    MOV BL, 4        ; BL = contador por linha
    
IMPRIME_LETRA:
    ; Imprime letra
    MOV AH, 2
    INT 21h
    
    ; Decrementa contador da linha
    DEC BL
    
    ; Se contador = 0, pula linha
    CMP BL, 0
    JNZ PROXIMA_LETRA
    
    ; Pula linha
    MOV AH, 9
    LEA DX, NOVA_LINHA
    INT 21h
    MOV BL, 4        ; Reinicia contador
    
PROXIMA_LETRA:
    ; Próxima letra
    INC DL
    
    ; Verifica se chegou em 'z'+1 (123)
    CMP DL, 123
    JNZ IMPRIME_LETRA
    
    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN