TITLE Somar os componentes do vetor
MODEL SMALL
STACK 100h
.DATA
    lista DW 0,1,2,1,1,0,1,1,1,1
.CODE
    MOV AX, @DATA
    MOV DS, AX

    XOR AX,AX ;acumulador
    XOR BX,BX; zerando bz que é o indice do vetor
    MOV CX, 5 ; contator inicializado no de elementos

SOMA:
    ADD AX, [lista + BX]

    ADD BX, 2
    LOOP SOMA
    PUSH AX      
    MOV DL, ''
    MOV AH, 2
    INT 21h
    POP AX
    MOV DL, AL
    OR DL, 30h
    INT 21h

    ; AX1: 30
