.TITLE SOMAR DOIS NUMEROS
.MODEL SMALL
.STACK 100h
.DATA
    NUM1 DB 5 ; declarei a variavel NUM1 e atribui o valor 5
    NUM2 DB 10 ; declarei a variavel NUM2 e atribui o valor 10
    RESULTADO DB ? ; declarei a variavel RESULTADO sem valor definido
    MSG1 DB 'O resultado da soma e: $' ; mensagem para imprimir antes do resultado
    MSG2 DB 10,13,'$' ; nova linha
.CODE

    ; Inicializa segmento de dados
    MOV AX, @DATA ; Pega o endereco do segmento de data e joga em no registrador AX
    MOV DS, AX ; Pega o valor do registrador AX e joga no registrador DS

    ; Início do programa
    MAIN PROC 
    MOV AL, NUM1 ; Movi o valor de num1 para Al
    ADD AL, NUM2 ; Al + num2
    MOV RESULTADO, AL ; Movi o valor de Al para resultado

    ; Imprime mensagem
    MOV AH, 4CH ; função para finalizar o programa
    INT 21H

MAIN ENDP
END MAIN
; Fim do programaS
