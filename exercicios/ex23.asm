title Soma acumulada
.model small
.stack 100h
.data
    msg db 'Soma de 1 ate 5: $'
.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg
    int 21h

    mov cx, 5        ; contador: 5 vezes
    mov ax, 0        ; acumulador da soma (AX = 0)
    mov bx, 1        ; número inicial (BX = 1)

repetir:
    add ax, bx       ; soma atual
    inc bx           ; próximo número
    loop repetir     ; decrementa CX e repete até CX = 0

    ; converte resultado (AX = 15) para caractere
    mov bx, 10
    mov dx, 0
    div bx           ; divide AX por 10 → AL=unidade, AH=dezena

    add ah, 30h      ; converte dezena pra ASCII
    add al, 30h      ; converte unidade pra ASCII

    ; mostra o resultado
    mov dl, ah
    mov ah, 02h
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h

    mov ah, 4Ch
    int 21h
main endp
end main
