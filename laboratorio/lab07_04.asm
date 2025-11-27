TITLE MAIOR E MENOR
.MODEL SMALL
.STACK 100h
.DATA
    msg1 DB 'Digite o primeiro numero (0-9): $'
    msg2 DB 0Dh,0Ah,'Digite o segundo numero (0-9): $'
    msgMaior DB 0Dh,0Ah,'Maior: $'
    msgMenor DB 0Dh,0Ah,'Menor: $'
    num1 DB ?
    num2 DB ?
.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

;mensagem 1
    MOV AH, 09h
    LEA DX, msg1
    INT 21h

;ler primeiro numero
    MOV AH, 01h
    INT 21h
    SUB AL, 30h       ; ASCII -> número
    MOV num1, AL

;mensagem 2
    MOV AH, 09h
    LEA DX, msg2
    INT 21h

;ler segundo numero
    MOV AH, 01h
    INT 21h
    SUB AL, 30h
    MOV num2, AL

;comparação
    MOV AL, num1
    MOV BL, num2
    CMP AL, BL
    JG PRIMEIRO_MAIOR   ; Se num1 > num2, vai para PRIMEIRO_MAIOR
    JL SEGUNDO_MAIOR    ; Se num1 < num2, vai para SEGUNDO_MAIOR
    ; Se forem iguais
    JMP IGUAIS

;primeiro maior
PRIMEIRO_MAIOR:
    ;mostrar maior
    MOV AH, 09h
    LEA DX, msgMaior
    INT 21h
    MOV DL, num1
    ADD DL, 30h
    MOV AH, 02h
    INT 21h

    ;mostrar menor
    MOV AH, 09h
    LEA DX, msgMenor
    INT 21h
    MOV DL, num2
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    JMP FIM

;segundo maior
SEGUNDO_MAIOR:
    ;mostrar maior
    MOV AH, 09h
    LEA DX, msgMaior
    INT 21h
    MOV DL, num2
    ADD DL, 30h
    MOV AH, 02h
    INT 21h

    ;mostrar menor
    MOV AH, 09h
    LEA DX, msgMenor
    INT 21h
    MOV DL, num1
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    JMP FIM

;caso sejam iguais
IGUAIS:
    MOV AH, 09h
    LEA DX, msgMaior
    INT 21h
    MOV DL, num1
    ADD DL, 30h
    MOV AH, 02h
    INT 21h

    MOV AH, 09h
    LEA DX, msgMenor
    INT 21h
    MOV DL, num2
    ADD DL, 30h
    MOV AH, 02h
    INT 21h
    JMP FIM

;fim do programa
FIM:
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN
