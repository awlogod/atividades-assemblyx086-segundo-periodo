; filepath: /Users/dede/Documents/Faculdade/assembly/lab05_01.asm
TITLE Imprime_Asteriscos
.MODEL SMALL
.STACK 100h
.DATA
    CONTADOR DW 50   ; Contador para 50 asteriscos
    ASTERISCO DB '*$'
    NOVA_LINHA DB 10,13,'$'  ; Caracteres para nova linha

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX

    ; Inicializa contador
    MOV CX, CONTADOR    ; CX = 50

HORIZONTAL:
    ; Imprime asterisco
    MOV AH, 2          
    MOV DL, '*'        
    INT 21h
    
    ; Decrementa contador
    DEC CX             
    JNZ HORIZONTAL     ; Pula se CX não for zero

    ; Pula linha
    MOV AH, 9
    LEA DX, NOVA_LINHA
    INT 21h

    ; Reinicializa contador
    MOV CX, CONTADOR   

VERTICAL:
    ; Imprime asterisco
    MOV AH, 2          
    MOV DL, '*'
    INT 21h
    
    ; Nova linha
    MOV AH, 9          
    LEA DX, NOVA_LINHA
    INT 21h
    
    ; Decrementa e verifica
    DEC CX             
    JNZ VERTICAL       ; Pula se CX não for zero

    ; Finaliza programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN