TITLE Soma de dois numeros
.DATA
    MSG1 DB 'Digite um primeiro numero: $'
    MSG2 DB 10,13,'Digite um segundo numero: $'
    MSG3 DB 10,13,'A soma dos dois numeros eh: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Mostra primeira mensagem
    MOV AH, 9
    LEA DX, MSG1
    INT 21h

    ; Le o primeiro numero
    MOV AH, 1
    INT 21h
    SUB AL, 30h     ; Converte de ASCII
    MOV BL, AL      ; Armazena em BL

    ; Mostra segunda mensagem
    MOV AH, 9
    LEA DX, MSG2
    INT 21h

    ; Le o segundo numero
    MOV AH, 1
    INT 21h
    SUB AL, 30h     ; Converte de ASCII
    
    ; Soma os numeros
    ADD AL, BL
    ADD AL, 30h     ; Converte para ASCII
    MOV BL, AL      ; Armazena resultado

    ; Mostra mensagem do resultado
    MOV AH, 9
    LEA DX, MSG3
    INT 21h

    ; Mostra a soma
    MOV AH, 2
    MOV DL, BL
    INT 21h

    ; Finaliza o programa
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN