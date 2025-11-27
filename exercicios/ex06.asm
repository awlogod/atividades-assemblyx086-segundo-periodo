TITLE PAR E IMPAR
.MODEL small
.STACK 100h
.DATA
    msg DB 'Digite um digito: $'
    NPAR DB 'Par'
    NIMPAR DB 'Impar'
.CODE
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 01h
    INT 21h

    MOV AH, 09h
    LEA DX, msg
    INT 21h

    AND BL, 0Fh
    TEST AL , 1
    JZ NPAR

    MOV AH, 09h
    LEA DX, NIMPAR


    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN

