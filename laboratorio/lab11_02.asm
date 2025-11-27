DividirPotencia2 PROC
    push cx            ; Salva CX na pilha (boa prática)
    pushf              ; Salva flags (caso use em código maior)

    ; Verifica se CL é zero (2^0 = 1, não precisa dividir)
    cmp cl,0
    je  FimDivisao

    ; Desloca AX CL vezes para a direita → divide por 2^CL
    sar ax,cl          ; SAR preserva o sinal (diferente de SHR)

FimDivisao:
    popf               ; Restaura flags
    pop cx             ; Restaura CX original
    ret
DividirPotencia2 ENDP
