TITLE Imprime um numero binario
.MODEL SMALL
.STACK 100h
.DATA
.CODE
MAIN PROC
    MOV CX,16        ; contador = 16 bits
L1:
    ROL BX,1         ; rotaciona BX à esquerda
    MOV DL,'0'       ; DL = '0' por padrão
    JNC P            ; se CF=0, pula
    MOV DL,'1'       ; se CF=1, muda para '1'
P:
    MOV AH,2
    INT 21h          ; imprime caractere
    LOOP L1
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
