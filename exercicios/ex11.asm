TITLE Imprima uma matriz 3x4
MODEL SMALL
Stack 100h
.DATA
    MATRIZ DW 1,2,3,4
           DW 5,6,7,8
           DW 9,9,9,9
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 2
    XOR BX, BX

VOLTA1:
     XOR SI, SI
     MOV CX, 4
    VOLTA2:
    MOV DX, MATRIZ [BX][SI]
    OR DL, 30h
    INT 21h
    MOV DL,' '
    INT 21H
    ADD SI, 2
    LOOP VOLTA2
;    INT 21
    ADD BX, 8
    CMP BX, 16
    JBE VOLTA1

    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN