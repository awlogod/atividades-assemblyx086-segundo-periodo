TITLE Par ou Impar
.MODEL SMALL
.STACK 100h
.DATA
    msg DB 'Digite um numero: $'
    par DB 'Eh par! $'
    impar DB 'Eh impar! $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ;le a mensagem 1
    MOV AH, 09h
    LEA DX, msg
    INT 21h

    MOV AH, 01h
    INT 21h
    SUB AL, 30h         ; Converter de ASCII para número
    MOV msg, AL
    MOV BL, AL ; move o nunmero para BL

    ;verificar e imprimir primeiro número
    MOV AL, BL
    MOV DL, BL
    ADD DL, 30h      ; volta para ASCII
    MOV par+11, DL   ; coloca número na string "par"
    MOV impar+13, DL ; coloca número na string "impar"

    TEST AL, 1       ; testa o bit menos significativo
    JZ eh_par1       ; se zero -> par

eh_impar1:
    MOV AH, 09h
    LEA DX, impar
    INT 21h
    JMP verifica2

eh_par1:
    MOV AH, 09h
    LEA DX, par
    INT 21h

FIM:
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN
