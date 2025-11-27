TITLE Imprime * (DO WHILE)
.Model small
.Stack 100h
.DATA
    msg1 DB 'Digite um caracter (ENTER para terminar): $ '
    count DW 0
    asterisk DB '*$'
.CODE
Main PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; Exibe mensagem inicial
    MOV AH, 09h
    LEA DX, msg1
    INT 21h

    ; Loop DO-WHILE para leitura
    LER_CHAR:
        MOV AH, 01h           ; Função para ler caractere
        INT 21h              
        INC count             ; Incrementa contador
        CMP AL, 0Dh           ; Compara com ENTER (CR)
        JNE LER_CHAR         ; Se não for ENTER, continua lendo

    DEC count                ; Ajusta contador (remove ENTER)

    ; Loop para imprimir asteriscos
    MOV CX, count           ; Prepara contador para loop
    LOOP_ASTERISCO:
        CMP CX, 0           ; Verifica se terminou
        JE FIM              ; Se sim, finaliza
        
        MOV AH, 09h         ; Função para imprimir string
        LEA DX, asterisk    ; Carrega endereço do asterisco
        INT 21h             ; Imprime
        
        DEC CX              ; Decrementa contador
        JMP LOOP_ASTERISCO  ; Continua loop

    FIM:
        MOV AH, 4Ch         ; Função para terminar programa
        INT 21h
Main ENDP
END Main

; A diferença do primeiro código para este segundo é, No WHILE, a condição é testada antes do laço, então ele pode não executar nenhuma vez.
;No REPEAT, a condição é testada depois, garantindo pelo menos uma execução.