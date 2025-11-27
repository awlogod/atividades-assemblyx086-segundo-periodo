TITLE teste 
.MODEL SMALL
.STACK 0100H
INCLUDE  macro.inc
.DATA
    N EQU 3
    VET DB N DUP(33H)
.CODE 
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX

        IMP_VET VET, N

        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN