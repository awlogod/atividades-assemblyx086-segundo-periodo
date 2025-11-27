TITLE Conversor Maiusculo
.MODEL SMALL
.DATA
    MSG1 DB 'Digite uma letra minuscula: $'
    MSG2 DB 10,13,'A letra maiuscula correspondente eh: $'

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; Exibe primeira mensagem
    MOV AH, 9
    LEA DX, MSG1
    INT 21h

    ; Le caractere
    MOV AH, 1
    INT 21h
    
    ; Converte para maiuscula (subtrai 32)
    SUB AL, 32
    MOV BL, AL
    
    ; Exibe segunda mensagem
    MOV AH, 9
    LEA DX, MSG2
    INT 21h
    
    ; Exibe letra convertida
    MOV AH, 2
    MOV DL, BL
    INT 21h
    
    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
    
MAIN ENDP
END MAIN