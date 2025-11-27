TITLE Verifica_Caractere
.MODEL SMALL
.STACK 100h ; reserva uma pilha de 100 bytes
.DATA
    MSG1 DB 'Digite ESC para finalizar$'
    MSG2 DB 10,13,'Digite um caractere: $'
    MSG_LETRA DB 10,13,'O caractere digitado e uma letra.$'
    MSG_NUM DB 10,13,'O caractere digitado e um numero.$'
    MSG_DESC DB 10,13,'O caractere digitado e desconhecido.$'
    MSG_FIM DB 10,13,'Fim do programa.$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

LOOP_PRINCIPAL:
    ; Mostra mensagem inicial
    MOV AH, 9
    LEA DX, MSG1
    INT 21h
    
    ; Solicita caractere
    MOV AH, 9
    LEA DX, MSG2
    INT 21h
    
    ; Le caractere
    MOV AH, 1
    INT 21h
    
    ; Verifica se é ESC (27)
    CMP AL, 27
    JE FIM_PROGRAMA
    
    ; Verifica se é letra (A-Z ou a-z)
    CMP AL, 'A'
    JB NAO_LETRA
    CMP AL, 'z'
    JA NAO_LETRA
    CMP AL, 'Z'
    JB EH_LETRA
    CMP AL, 'a'
    JAE EH_LETRA
    
NAO_LETRA:
    ; Verifica se é número (0-9)
    CMP AL, '0'
    JB DESCONHECIDO
    CMP AL, '9'
    JA DESCONHECIDO
    
    ; É número
    MOV AH, 9
    LEA DX, MSG_NUM
    INT 21h
    JMP LOOP_PRINCIPAL
    
EH_LETRA:
    MOV AH, 9
    LEA DX, MSG_LETRA
    INT 21h
    JMP LOOP_PRINCIPAL
    
DESCONHECIDO:
    MOV AH, 9
    LEA DX, MSG_DESC
    INT 21h
    JMP LOOP_PRINCIPAL
    
FIM_PROGRAMA:
    MOV AH, 9
    LEA DX, MSG_FIM
    INT 21h
    
    MOV AH, 4Ch
    INT 21h
    
MAIN ENDP
END MAIN