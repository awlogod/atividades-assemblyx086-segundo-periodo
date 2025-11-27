TITLE Somatorio
.MODEL SMALL
.STACK 100h
.DATA
    MSG1 DB 'Digite um numero (0-9): $'
    MSG2 DB 10,13,'A soma eh: $'
    SOMA DB 0   ; Variável para armazenar a soma

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX
    
    ; Inicializa contador
    MOV CX, 5         ; Vamos ler 5 números
    MOV BL, 0         ; BL armazena a soma

LER_NUMERO:
    ; Exibe mensagem
    MOV AH, 9
    LEA DX, MSG1
    INT 21h
    
    ; Lê um dígito
    MOV AH, 1
    INT 21h
    
    ; Converte ASCII para número
    SUB AL, 30h
    
    ; Adiciona à soma
    ADD BL, AL
    
    ; Decrementa contador
    DEC CX
    JNZ LER_NUMERO    ; Continua se não leu 5 números
    
    ; Exibe mensagem do resultado
    MOV AH, 9
    LEA DX, MSG2
    INT 21h
    
    ; Converte soma para ASCII
    MOV DL, BL
    ADD DL, 30h
    
    ; Exibe soma
    MOV AH, 2
    INT 21h
    
    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN