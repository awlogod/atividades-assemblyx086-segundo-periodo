TITLE Vetor Escrito Inverso
.Model SMALL
.STACK 100h
.DATA
    vetor DB '1234', '$'    ; Usando DB para caracteres
    tam EQU ($-vetor-1)       ; Calcula tamanho do vetor

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; Exibe string original
    MOV AH, 09h
    LEA DX, vetor
    INT 21h

    ; Nova linha
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV DL, 0Ah
    INT 21h

    ; Prepara para inversão
    LEA SI, vetor
    ADD SI, tam               ; Aponta para último caractere

    MOV CX, tam + 1          ; Contador = tamanho do vetor

INVERTE:
    MOV DL, [SI]             ; Pega caractere atual
    MOV AH, 02H              ; Função de impressão
    INT 21H                  ; Imprime caractere
    
    DEC SI                   ; Move para caractere anterior
    LOOP INVERTE            ; Repete até CX = 0

    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN