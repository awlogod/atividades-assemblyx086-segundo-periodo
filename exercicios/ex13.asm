TITLE Definir uma matriz 3x3 e preencher e imprimir
MODEL SMALL
STACK 100h
.DATA

    matriz DW ?,?,? ; 0
           DW ?,?,?; 6
           DW ?,?,? ; 12
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 01H
    XOR BX, BX

VOLTA1: 
XOR SI, SI
MOV CX, 3

VOLTA2:
INT 21H
MOV MATRIZ[BX][SI], AL
LOOP VOLTA2
ADD BX, 6
CMP BX, 12
JBE VOLTA1

MOV AH, 04CH
INT 21H

MAIN ENDP
END MAIN