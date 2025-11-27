; Fazer um programa que identifique se é par ou iimpar (mprimir o resultado- usar deslocamento)
.TITLE PAR E IMPAR II
.MODEL small
.STACK 100h
.DATA
    msg DB 'Digite um número: $'
    NPAR DB 'Par'
    NIMPAR DB 'Impar'
.CODE
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 09
    LEA DX, msg
    INT 21

    MOV AH, 01
    INT 21

    XOR BL, BL


    MOV 4Ch
    INT 21h
MAIN ENDP
END MAIN