TITLE Juncao de todos os outros programas
.MODEL SMALL
.STACK 100h
.DATA
menu DB 13,10,'1- Ler Binario',13,10
     DB '2- Ler Hexa',13,10
     DB '3- Mostrar Binario',13,10
     DB '4- Mostrar Hexa',13,10
     DB 'Opcao: $'
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

INICIO:
    MOV AH,9
    LEA DX,menu
    INT 21h          ; exibe menu
    MOV AH,1
    INT 21h          ; lê opção
    CMP AL,'1'
    JE LERBIN
    CMP AL,'2'
    JE LERHEX
    CMP AL,'3'
    JE MOSTRABIN
    CMP AL,'4'
    JE MOSTRAHEX
    JMP INICIO

;Procedimento 1: Leitura Binária
LERBIN:
    MOV BX,0
L1:
    MOV AH,1
    INT 21h
    CMP AL,13
    JE INICIO
    SHL BX,1
    SUB AL,'0'
    OR  BL,AL
    JMP L1

;Procedimento 2: Leitura Hexadecimal
LERHEX:
    MOV BX,0
L2:
    MOV AH,1
    INT 21h
    CMP AL,13
    JE INICIO
    SHL BX,4
    CMP AL,'9'
    JG LTR
    SUB AL,'0'
    JMP INS
LTR:SUB AL,55
INS:OR BL,AL
    JMP L2

;Procedimento 3: Impressão Binária
MOSTRABIN:
    MOV CX,16
L3:
    ROL BX,1
    MOV DL,'0'
    JNC P0
    MOV DL,'1'
P0: MOV AH,2
    INT 21h
    LOOP L3
    JMP INICIO

;Procedimento 4: Impressão Hexadecimal
MOSTRAHEX:
    MOV CX,4
L4:
    MOV DL,BH
    SHR DL,4
    CMP DL,9
    JG LTR2
    ADD DL,'0'
    JMP OUT
LTR2:
    ADD DL,55
OUT:
    MOV AH,2
    INT 21h
    ROL BX,4
    LOOP L4
    JMP INICIO

MAIN ENDP
END MAIN