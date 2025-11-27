TITLE Leitura de um numero binario do teclado
.MODEL SMALL
.STACK 100h
.DATA
.CODE
MAIN PROC
    MOV BX,0        ; limpa BX
L1:
    MOV AH,1
    INT 21h         ; lê caractere
    CMP AL,13       ; CR? (Enter)
    JE FIM
    SHL BX,1        ; desloca BX 1 bit à esquerda
    SUB AL,'0'      ; converte '0'/'1' -> 0/1
    OR  BL,AL       ; insere no bit menos significativo
    JMP L1
FIM:
    MOV AH,4Ch
    INT 21h
MAIN ENDP
END MAIN
