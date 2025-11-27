.TITLE Ler e imprimir e somar matriz 4×4
.MODEL SMALL
.STACK 100h

.DATA
msgTit  DB 13,10,'PARTE 3',13,10,'$'
msgLer  DB 'Digite 16 valores (0..6):',13,10,'$'
msgMat  DB 13,10,'Matriz:',13,10,'$'
msgSoma DB 13,10,'Soma = ','$'
msgFim  DB 13,10,'[FIM]',13,10,'$'
spc     DB ' ','$'
nl      DB 13,10,'$'

MATRIZ  DB 16 DUP(?)
SOMA    DW 0

.CODE
PrintStr PROC
    MOV AH,09h
    INT 21h
    RET
PrintStr ENDP

Read06 PROC
R:
    MOV AH,01h
    INT 21h
    SUB AL,'0'
    CMP AL,0
    JL R
    CMP AL,6
    JG R
    RET
Read06 ENDP

PrintDig PROC
    ADD AL,'0'
    MOV DL,AL
    MOV AH,02h
    INT 21h
    RET
PrintDig ENDP

PrintDec PROC
    PUSH AX BX CX DX
    MOV BX,10
    XOR CX,CX
    CMP AX,0
    JNE L1
    MOV DL,'0'
    MOV AH,02h
    INT 21h
    JMP F
L1:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE L1
L2:
    POP DX
    ADD DL,'0'
    MOV AH,02h
    INT 21h
    LOOP L2
F:
    POP DX CX BX AX
    RET
PrintDec ENDP

LerMatriz PROC
    LEA DI,MATRIZ
    MOV CX,16
L:
    CALL Read06
    MOV [DI],AL
    INC DI
    LOOP L
    RET
LerMatriz ENDP

ImprimirMatriz PROC
    LEA DI,MATRIZ
    MOV CX,16
    MOV BX,0
P:
    MOV AL,[DI]
    CALL PrintDig
    LEA DX,spc
    CALL PrintStr
    INC DI
    INC BX
    CMP BX,4
    JNE N
    MOV BX,0
    LEA DX,nl
    CALL PrintStr
N:
    LOOP P
    RET
ImprimirMatriz ENDP

SomarMatriz PROC
    LEA DI,MATRIZ
    MOV CX,16
    XOR AX,AX
S:
    ADD AL,[DI]
    AAA
    INC DI
    LOOP S
    MOV [SOMA],AX
    RET
SomarMatriz ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,msgTit
    CALL PrintStr
    LEA DX,msgLer
    CALL PrintStr

    CALL LerMatriz

    LEA DX,msgMat
    CALL PrintStr
    CALL ImprimirMatriz

    CALL SomarMatriz

    LEA DX,msgSoma
    CALL PrintStr
    MOV AX,SOMA
    CALL PrintDec

    LEA DX,msgFim
    CALL PrintStr

    MOV AH,4Ch
    INT 21h
MAIN ENDP

END MAIN
