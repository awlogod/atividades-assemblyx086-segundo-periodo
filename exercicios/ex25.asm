.model small
.stack 100h

.data
msgM    db 0Dh,0Ah,'Digite m (0-9): $'
msgN    db 0Dh,0Ah,'Digite n (0-9): $'
msgErro db 0Dh,0Ah,'[ERRO] m deve ser menor que n e n!=0',0Dh,0Ah,'$'
msgRes  db 0Dh,0Ah,'Resultado: 0.', '$'

.code
main PROC
    mov ax,@data
    mov ds,ax

; ---- Ler m ----
    mov dx,offset msgM
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h            ; AL = caractere
    sub al,'0'         ; converte para número
    cmp al,9
    ja erro
    mov bl,al          ; BL = m (resto inicial)

; ---- Ler n ----
    mov dx,offset msgN
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    cmp al,9
    ja erro
    cmp al,0
    je erro
    cmp bl,al
    jae erro           ; exige m < n
    mov cl,al          ; CL = n (divisor)

; ---- Mostrar "0." ----
    mov dx,offset msgRes
    mov ah,09h
    int 21h

; ---- Calcula decimais (5 casas) ----
    mov ch,5           ; CH será o contador de dígitos

LoopDecimal:
    mov al,bl          ; AL = resto
    mov ah,0
    mov dl,10
    mul dl             ; AX = resto * 10

    div cl             ; AL = quociente, AH = novo resto
    add al,'0'         ; converte p/ ASCII
    mov dl,al
    mov ah,02h
    int 21h            ; imprime o dígito

    mov bl,ah          ; resto = AH
    dec ch
    jnz LoopDecimal

; ---- Finalizar ----
    mov ah,4Ch
    int 21h

erro:
    mov dx,offset msgErro
    mov ah,09h
    int 21h
    mov ah,4Ch
    int 21h

main ENDP
end main
