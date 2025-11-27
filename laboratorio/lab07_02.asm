TITLE multiplicação entre dois númeroS por meio de somas sucessivas
.MODEL SMALL
.STACK 100h
.DATA
    msg1 DB 'Dgite o multiplicado: $'
    msg2 DB 'Digite o multiplicador: $'
    msg3 DB 'Resultado: $'
    multiplicado DB ?
    multiplicador DB ?
    resultado DB ?
.CODE
MAIN PROC

    MOV AX, @DATA
    MOV DS, AX

    ;le o multiplicado
    MOV AH, 09h
    LEA DX, msg1
    INT 21h

    MOV AH, 01h
    SUB AL, 30h          ; Converter de ASCII para número
    MOV multiplicado, AL
    INT 21h

    ;le o multiplicador
    MOV AH, 09h
    LEA DX, msg2
    INT 21h

    MOV AH, 01h
    SUB AL, 30h          ; Converter de ASCII para número
    MOV multiplicador, AL
    INT 21h

    ;inicializa o resultado
    MOV resultado, 0

    ;loop das somas sucessivas
    MOV CL, multiplicado
    MOV AL, multiplicador
    MOV BL, AL
    MOV AL, 0

SOMA_LOOP:
    CMP CL, 0
    JE FIM_MULT
    ADD AL, BL
    DEC CL
    JMP SOMA_LOOP

FIM_MULT:
MOV resultado, AL 

    ;mostro a mensagem 3
    MOV AH, 09h
    LEA DX, msg3
    INT 21h

    ;mostro resultado
    MOV AL, resultado
    ADD AL, 30h             ; converter para ASCII
    MOV DL, AL
    MOV AH, 02h             ; imprimir caractere
    INT 21h

    ;Fim do programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN