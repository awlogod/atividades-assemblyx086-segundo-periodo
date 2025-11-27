.MODEL small
.STACK 100h
.DATA
    msg DB 0Dh,0Ah,'Digite um caracter (0 para sair): $'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

LOOP_MENSAGEM:
 
    MOV AH, 09h
    LEA DX, msg
    INT 21h


    MOV AH, 01h
    INT 21h

   
    CMP AL,'0'
    JE SAI

    
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    
    JMP LOOP_MENSAGEM

SAI:
    
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN
