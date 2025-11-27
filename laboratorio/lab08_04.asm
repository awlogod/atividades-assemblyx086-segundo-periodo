TITLE Imprime um numero hexadecimal
.MODEL SMALL
.STACK 100h
.DATA
.CODE
MAIN PROC
    MOV CX,4        ; 4 dígitos hexadecimais
L1:
    MOV DL,BH       ; move parte alta de BX para DL
    SHR DL,4        ; desloca 4 bits à direita
    CMP DL,9
    JG LETRA
    ADD DL,'0'      ; 0–9
    JMP IMPR
LETRA:
    ADD DL,55       ; A–F (10+55=65='A')
IMPR:
    MOV AH,2
    INT 21h         ; imprime caractere
    ROL BX,4        ; roda BX 4 bits à esquerda
    LOOP L1
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
