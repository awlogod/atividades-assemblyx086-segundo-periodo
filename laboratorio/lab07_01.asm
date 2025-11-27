TITLE DIVISAO
.MODEL SMALL
.STACK 100
.DATA
    msg1 DB 'Digite o dividendo (0-9): $'
    msg2 DB 0Dh,0Ah,'Digite o divisor (0-9): $'
    msg3 DB 0Dh,0Ah,'Quociente: $'
    msg4 DB 0Dh,0Ah,'Resto: $'
    dividendo DB ?
    divisor   DB ?
    quociente DB ?
    resto     DB ?
.CODE
Main PROC
    MOV AX, @DATA
    MOV DS, AX

    ;le a primeira mensagem
    MOV AH 09
    LEA DS, msg1
    INT 21H

    MOV AH, 01h
    INT 21H
    SUB AL, 30h
    MOV dividendo, AL

    ;le divisor
    MOV AH 09
    LEA DS, msg1
    INT 21H

    MOV AH, 01h
    INT 21H
    SUB AL, 30h
    MOV dividendo, AL

    ;Inicializa quociente
    MOV quociente, 0
    MOV AL, dividendo
    MOV BL, divisor

    ;Loop de subtrações
DIV_LOOP:
    CMP AL, BL
    JL FIM_DIVISAO       ; se AL < BL, terminou
    SUB AL, BL           ; AL = AL - BL
    INC quociente        ; soma 1 ao quociente
    JMP DIV_LOOP

FIM_DIVISAO:
    MOV resto, AL

;Mostrar quociente
    MOV AH, 09h
    LEA DX, msg3
    INT 21h

    MOV AL, quociente
    ADD AL, 30h
    MOV DL, AL
    MOV AH, 02h
    INT 21h

;Mostrar resto
    MOV AH, 09h
    LEA DX, msg4
    INT 21h

    MOV AL, resto
    ADD AL, 30h
    MOV DL, AL
    MOV AH, 02h
    INT 21h

;Encerrar programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN