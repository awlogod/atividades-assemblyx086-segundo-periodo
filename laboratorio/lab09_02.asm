.TITLE Imprime a matriz 4x4 em formato de linhas x colunas
.MODEL SMALL
.STACK 100h

.DATA
    msgTitulo   DB 13,10,'IMPRIMIR MATRIZ 4x4',13,10,'$'
    msgFim      DB 13,10,'[FIM]',13,10,'$'
    esp         DB ' ', '$'
    nl          DB 13,10,'$'

    MATRIZ4X4   DB 1,2,3,4
                DB 4,3,2,1
                DB 5,6,7,8
                DB 8,7,6,5

.CODE
PrintStr PROC
    MOV AH,09h
    INT 21h
    RET
PrintStr ENDP

; imprime número (0..9) como dígito
PrintDigit PROC
    ; AL = valor 0..9
    ADD AL,'0'
    MOV DL,AL
    MOV AH,02h
    INT 21h
    RET
PrintDigit ENDP

; Imprime matriz 4x4
; DI -> base da matriz
; SI = offset da linha (0,4,8,12)
; BX = coluna (0..3)
PrintMatriz PROC
    LEA DI, MATRIZ4X4
    XOR SI,SI          ; offset linha = 0
    MOV BP,4           ; qtde de linhas
Linhas:
    XOR BX,BX        ; col = 0
    MOV CX,4           ; 4 colunas
Colunas:
    MOV AL,[DI+SI+BX]
    CALL PrintDigit
    LEA DX,esp
    CALL PrintStr
    INC BX
    LOOP Colunas

    LEA DX,nl
    CALL PrintStr

    ADD SI,4           ; próxima linha (salto de 4 bytes)
    DEC BP
    JNZ Linhas
    RET
PrintMatriz ENDP

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,msgTitulo
    CALL PrintStr

    CALL PrintMatriz

    LEA DX,msgFim
    CALL PrintStr

    MOV AH,4Ch
    XOR AL,AL
    INT 21h
MAIN ENDP

END MAIN
