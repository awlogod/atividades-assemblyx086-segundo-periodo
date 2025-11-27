; Procedimento: Espelha uma palavra na memória
; Entrada:
;   BL = endereço (offset) da palavra terminada em '$'
; Saída:
;   A própria palavra é invertida na memória
; Registradores preservados: SI, DI, AL, AH

EspelhaPalavra PROC
    push si
    push di
    push ax
    push dx

    mov si, bx           ; SI aponta para o início da palavra

    ; Achar o final da string (SI percorre até achar '$')
LocalizaFim:
    mov al, [si]
    cmp al, '$'
    je FimEncontrado
    inc si
    jmp LocalizaFim

FimEncontrado:
    dec si               ; Agora SI aponta para o último caractere válido
    mov di, bx           ; DI aponta para o início

; Agora trocamos DI e SI até cruzarem
EspelhaLoop:
    cmp di, si
    jge EspelhaFim       ; Se encontram ou passam, já terminou

    mov al, [di]         ; AL = caractere do início
    mov ah, [si]         ; AH = caractere do fim

    mov [di], ah         ; coloca o final no início
    mov [si], al         ; coloca o início no final

    inc di               ; avança início
    dec si               ; recua fim
    jmp EspelhaLoop

EspelhaFim:
    pop dx
    pop ax
    pop di
    pop si
    ret
EspelhaPalavra ENDP
