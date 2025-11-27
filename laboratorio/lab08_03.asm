TITLE Le um numero hexadecimal do teclado
.MODEL SMALL
.STACK 100h
.DATA
.CODE
MAIN PROC
    MOV BX,0        ; zera BX
L1:
    MOV AH,1
    INT 21h         ; lê caractere
    CMP AL,13       ; Enter (CR)?
    JE FIM
    SHL BX,4        ; desloca 4 bits à esquerda
    CMP AL,'9'
    JG LETRA
    SUB AL,'0'      ; '0'-'9'
    JMP INSERE
LETRA:
    SUB AL,55       ; 'A'-'F' → 65-55 = 10 ... 70-55 = 15
INSERE:
    OR  BL,AL       ; insere valor em BX
    JMP L1
FIM:
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
